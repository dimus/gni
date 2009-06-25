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
  attr_accessor :resource_uri
  attr_accessible :resource_uri
  
  unless defined? CONSTANTS_DEFINED
    LATIN_CHARACTERS =  ('A'..'Z')
    PARSING_CLEAN =     1
    PARSING_DIRTY =     2
    PARSING_CANONICAL = 3
    CONSTANTS_DEFINED = true
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
    table_term = "st:#{search_term},dsi:#{data_source_id},ui:#{user_id}"
    unless temp_table?(temp_table(table_term))
      qualifiers = {:au => 'author_word', :gen => 'genus', :sp => 'species', :yr => 'year', :uni => 'uninomial', :ssp => 'infraspecies'}
      qualifiers_list = "(au|gen|sp|yr|uni|ssp)"
      data_source_id = data_source_id.to_i
      user_id = user_id.to_i
      search_term_modified = search_term.gsub(/[\(\)\[\]|.,&;]/, ' ').gsub("*", '%').gsub(/\s+/, ' ')
      name_string_term = search_term_modified.match(/ns:(.*)$/) ? $1.strip : nil
      canonical_term = search_term_modified.match(/can:(.*?)(#{qualifiers_list}:|$)/) ? $1.strip : nil
      #search_term_modified = search_term_modified.gsub("can:"+canonical_term, '').gsub(/\s+/, ' ') if canonical_term
      #canonical_term = search_term_modified.match(/(can:'[^']+')/)
      search_words = search_term_modified.split(' ').uniq
      name_strings = nil
    
      search_words_size = search_words.size
      search_words_size += 1 if canonical_term
    
      if search_words_size > 0 
        search_words_prepared = []
        qualified_words = []
        search_words.each do |word|
          if !!word.match(/^#{qualifiers_list}:(.*)$/)
            qualified_words << [$1, $2]
          else
            search_words_prepared << word
          end
        end
      
        search_words = search_words_prepared
      
        search_words_string = "'" + search_words.join("','") + "'"
      
        select = "distinct ns.id, ns.name from name_strings ns join name_word_semantics nws ON (ns.id=nws.name_string_id) left join (semantic_meanings sm) ON (nws.semantic_meaning_id=sm.id) join name_words nw on (nws.name_word_id=nw.id)"
        suffix = "ORDER BY ns.name"
        regexes = []
      
        if (search_words.size + qualified_words.size) > 0 && !(canonical_term || name_string_term)
          where = "(1=2"
        
          search_words.each do |wcw|
            where += " OR word LIKE '#{wcw}'"
            regexes << prepare_regex(wcw)
          end
          qualified_words.each do |wcw|
            where += " OR (sm.name='#{qualifiers[wcw[0].to_sym]}' AND word LIKE '#{wcw[1]}')"
            regexes << prepare_regex(wcw[1])
          end
          where += ")"
          where +=  " and (ns.name rlike "
          where += regexes.map {|w| "'#{w}'"}.join(' and ns.name rlike ') + ")"
        end
      
      
        if canonical_term
          select = "ns.id, ns.name from name_strings ns join canonical_forms cf on (cf.id = ns.canonical_form_id)"
          where = ActiveRecord::Base.gni_sanitize_sql([" cf.name like ?", canonical_term])
          suffix = "ORDER BY ns.name"
        elsif name_string_term
          select = "ns.id, ns.name from name_strings ns"
          where = ActiveRecord::Base.gni_sanitize_sql([" ns.name like ?", name_string_term])
          suffix = 'ORDER BY ns.name'
        end
      
        if user_id > 0
           select += " join name_indices ni on (ns.id = ni.name_string_id) join data_source_contributors dsc on (ni.data_source_id = dsc.data_source_id)"
           where += " and dsc.user_id=" + user_id.to_s
        elsif data_source_id > 0
          select += " join name_indices ni on (ns.id = ni.name_string_id)"
          where += " AND ni.data_source_id = #{data_source_id}"
        end
        q = "create temporary table `#{temp_table(table_term)}` SELECT #{select} WHERE #{where} #{suffix}"
        ActiveRecord::Base.connection.execute(q)
      else
        q = "create temporary table `#{temp_table(table_term)}` (id int, name varchar(2))"
        ActiveRecord::Base.connection.execute(q)
      end
    end
    q = "select * from `#{temp_table(table_term)}`"
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
  
  def self.temp_table(table_term)
    Digest::SHA1.hexdigest(table_term)
  end
  
  def self.temp_table?(temp_table)
    tbl_name = ActiveRecord::Base.gni_sanitize_sql(['?', temp_table]).gsub("'",'')
    begin
      q = "select 1 from `#{tbl_name}`"
      ActiveRecord::Base.connection.select_value(q)
    rescue ActiveRecord::StatementInvalid => error
      return false
    end
    return true
  end
end
