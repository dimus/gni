class NameString < ActiveRecord::Base
  has_one :kingdom
  has_many :name_indices
  has_many :data_source_import_details
  has_many :data_sources, :through => :name_indices
  has_many :name_index_records, :through => :name_indices
  has_many :lexical_group_name_strings
  has_many :lexical_groups, :through => :lexical_group_name_strings
  belongs_to :canonical_form
  
  validates_presence_of :name
  validates_uniqueness_of :name
  attr_accessor :resource_uri, :uuid_hex, :lsid
  attr_accessible :resource_uri, :uuid_hex, :lsid
  
  unless defined? CONSTANTS_DEFINED
    LATIN_CHARACTERS =  ('A'..'Z')
    PARSING_CLEAN =     1
    PARSING_DIRTY =     2
    PARSING_CANONICAL = 3
    CONSTANTS_DEFINED = true
  end

  def uuid
    res = super
    res ? res : UUID.create_v5(NameString.normalize_name_string(name), GNA_NAMESPACE).raw_bytes
  end

  def self.uuid2bytes(uuid)
    UUID.parse(uuid).raw_bytes
  end
  
  def uuid_hex
    UUID.parse(self.uuid.unpack("H*")[0]).guid rescue nil
  end

  def lsid
    uuid_hex ? LSID_PREFIX + uuid_hex : nil
  end
  
  def self.prepare_search_term(search_term)
    search_term.gsub(/[\(\)\[\]|.,&;]/, ' ').gsub("*", '%').gsub(/\s+/, ' ') if search_term
  end
  
  def self.normalize_name_string(n_string)
    # n_string = n_string.gsub(/([\(\[])\s+/, '\1')
    # n_string = n_string.gsub(/([\,])(?=[^\s])/, '\1 ')
    # n_string = n_string.gsub(/\s+([\)\]\.\,\;\:])/, '\1')
    # n_string = n_string.gsub('&amp;', '&')
    # n_string = n_string.gsub(/([&])/, ' \1 ')
    n_string.gsub(/\s{2,}/, ' ').strip
  end
  
  def self.char_triples(latin_char)
    triples = []
    LATIN_CHARACTERS.each do |c1|
      triples_array = []
      LATIN_CHARACTERS.each do |c2|
        triples_array << latin_char + c1 + c2
      end
      triples << triples_array
    end
    triples
  end
  
  def self.search(search_term, data_source_id, user_id, page_number, items_per_page)
    search_term_modified = NameString.prepare_search_term(search_term)
    
    #special cases
    ns_id = search_term_modified.match(/id:(.*)$/) ? $1.strip.to_i : nil
    name_string_term = search_term_modified.match(/ns:(.*)$/) ? $1.strip : nil
    canonical_term = search_term_modified.match(/can:(.*?)$/) ? $1.strip : nil
    
    is_special_case = !!ns_id || !!name_string_term || !!canonical_term
    
    if is_special_case
      select, where , suffix = prepare_special_case_query(ns_id, name_string_term, canonical_term)
    else
      select, where, suffix = prepare_query(search_term_modified)
    end

    if select
      select, where = query_with_user_and_data_source(select, where, user_id, data_source_id)
      q = "SELECT #{select} WHERE #{where} #{suffix}"
    else
      q = "SELECT id, name, uuid from name_strings where 1=2"
    end  

    self.paginate_by_sql(q, :page => page_number, :per_page => items_per_page)
  end
 

  def self.delete_orphans()
    orphans = ActiveRecord::Base.connection.select_values("select ns.id from name_strings ns left join name_indices ni on ns.id = ni.name_string_id where name_string_id is null").join(",")
    ActiveRecord::Base.connection.execute("delete from name_strings where id in (#{orphans})") unless orphans.blank?
  end
  
private
  
  def self.prepare_regex(word)
    '(^|[^[:alnum:]-])' + word.gsub(/([^%])$/, '\1([^[:alnum:]-]|$)').gsub('%', '')
  end
  
  def self.prepare_special_case_query(ns_id, name_string_term, canonical_term)
    suffix = 'ORDER BY ns.name'
    if ns_id
      select = "ns.id, ns.name, ns.uuid from name_strings ns"
      where = "ns.id = %s" % ns_id.to_i
      suffix = ''
    elsif name_string_term
      select = "ns.id, ns.name, ns.uuid from name_strings ns"
      where = ActiveRecord::Base.gni_sanitize_sql([" ns.normalized like ?", name_string_term])
    elsif canonical_term
      select = "ns.id, ns.name, ns.uuid from name_strings ns join canonical_forms cf on (cf.id = ns.canonical_form_id)"
      where = ActiveRecord::Base.gni_sanitize_sql([" cf.name like ?", canonical_term])
    end
    [select, where, suffix]
  end
  
  def self.prepare_query(search_term_modified)
    search_words = search_term_modified.split(' ').uniq
    return nil,nil,nil if search_words.blank?
    
    qualifiers = {:au => 'author_word', :gen => 'genus', :sp => 'species', :yr => 'year', :uni => 'uninomial', :ssp => 'infraspecies'}
    qualifiers_list = "(au|gen|sp|yr|uni|ssp)"
    search_words_prepared = []
    qualified_words = []
    regexes = []
    
    search_words.each do |word|
      if !!word.match(/^#{qualifiers_list}:(.*)$/)
        qualified_words << [$1, Taxamatch::Normalizer.normalize($2)]
      else
        search_words_prepared << Taxamatch::Normalizer.normalize(word)
      end
    end

    select = "distinct ns.id, ns.name, ns.uuid from name_strings ns join name_word_semantics nws on (ns.id=nws.name_string_id) join name_words nw on (nws.name_word_id=nw.id)"    
    select += " left join (semantic_meanings sm) ON (nws.semantic_meaning_id=sm.id)" unless qualified_words.blank?
    where = "(1=2"
  
    search_words_prepared.each do |wcw|
      where += " OR word LIKE '#{wcw}'"
      regexes << prepare_regex(wcw)
    end

    qualified_words.each do |wcw|
      where += " OR (sm.name='#{qualifiers[wcw[0].to_sym]}' AND word LIKE '#{wcw[1]}')"
      regexes << prepare_regex(wcw[1])
    end

    where += ")"
    where +=  " and (ns.normalized rlike "
    where += regexes.map {|w| "'#{w}'"}.join(' and ns.normalized rlike ') + ")"
  
    suffix = "ORDER BY ns.name"
    [select, where, suffix]
  end
  
  def self.query_with_user_and_data_source(select, where, user_id, data_source_id)
    user_id = user_id.to_i
    data_source_id = data_source_id.to_i  
    if user_id > 0
       select += " join name_indices ni on (ns.id = ni.name_string_id) join data_source_contributors dsc on (ni.data_source_id = dsc.data_source_id)"
       where += " and dsc.user_id=" + user_id.to_s
    elsif data_source_id > 0
      select += " join name_indices ni on (ns.id = ni.name_string_id)"
      where += " AND ni.data_source_id = #{data_source_id}"
    end
    [select, where]
  end
  
end
