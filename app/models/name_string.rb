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
    qualifiers = {:au => 'author_word', :gen => 'genus', :sp => 'species', :yr => 'year', :uni => 'uninomial', :ssp => 'infraspecies'}
    qualifiers_list = "(au|gen|sp|yr|uni|ssp)"
    data_source_id = data_source_id.to_i
    user_id = user_id.to_i
    search_term = search_term.gsub(/[\(\)\[\].,&;]/, ' ').gsub(/\s+/, ' ')
    canonical_term = search_term.match(/can:(.*?)(#{qualifiers_list}:|$)/) ? $1.strip : nil
    search_term = search_term.gsub("can:"+canonical_term, '').gsub(/\s+/, ' ') if canonical_term
    #canonical_term = search_term.match(/(can:'[^']+')/)
    search_words = search_term.split(' ').uniq
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
      
      # wild_card_words.each do |wcw|
      #   wc_words = Action.find_by_sql("select word from name_words where word like '#{wcw}'").map {|r| r.word} rescue nil
      #   search_words += wc_words if wc_words
      # end
      
      search_words_string = "'" + search_words.join("','") + "'"
      
      select = "ns.id, ns.name from name_strings ns join name_word_semantics nws ON (ns.id=nws.name_string_id) left join (semantic_meanings sm) ON (nws.semantic_meaning_id=sm.id) join name_words nw on (nws.name_word_id=nw.id)"
      suffix = "GROUP BY ns.id HAVING count(distinct nws.id) >= #{search_words_size} ORDER BY ns.name"
      if (search_words.size + qualified_words.size) > 0
        where = "(1=2"
        
      
        search_words.each do |wcw|
          where += " OR word LIKE '#{wcw}'"
        end
        qualified_words.each do |wcw|
          where += " OR (sm.name='#{qualifiers[wcw[0].to_sym]}' AND word LIKE '#{wcw[1]}')"
        end
        where += ")"
      else
        #should only get here if searching with canonical form only
        where ="(1=2 OR cf.name = '#{canonical_term}')"
        suffix = "GROUP BY ns.id HAVING count(distinct cf.id) >= #{search_words_size} ORDER BY ns.name"
      end
      
      if canonical_term
        puts 'canonical'
        select += " left join canonical_forms cf on (ns.canonical_form_id=cf.id and cf.name='#{canonical_term}')"
        suffix = "GROUP BY ns.id HAVING (count(distinct nws.id)+count(distinct cf.id)) >= #{search_words_size} ORDER BY ns.name"
      end
      
      if user_id > 0
         select += " join name_indices ni on (ns.id = ni.name_string_id) join data_source_contributors dsc on (ni.data_source_id = dsc.data_source_id)"
         where += " and dsc.user_id=" + user_id.to_s
      elsif data_source_id > 0
        select += " join name_indices ni on (ns.id = ni.name_string_id)"
        where += " and ni.data_source_id = #{data_source_id}"
      end
      puts "SELECT #{select} WHERE #{where} #{suffix}"
      name_strings = self.paginate_by_sql("SELECT #{select} WHERE #{where} #{suffix}", :page => page_number, :per_page => items_per_page)
    end
    name_strings
  end
  # 
  #   if user_id
  #     name_strings = self.paginate_by_sql(["select distinct ns.id, ns.name from canonical_forms cf join name_strings ns on (cf.id = ns.canonical_form_id) join name_indices ni on (ns.id = ni.name_string_id) join data_source_contributors dsc on (ni.data_source_id = dsc.data_source_id)  where cf.name like ? and dsc.user_id = ? order by ns.name", search_term, user_id], :page => page_number, :per_page => items_per_page) || nil rescue nil
  #     if name_strings.blank?
  #       name_strings = self.paginate_by_sql(["select distinct n.id, n.name from name_strings n join name_indices i on (n.id = i.name_string_id) join data_source_contributors c on (i.data_source_id = c.data_source_id)  where n.name like ? and c.user_id = ? order by n.name", search_term, user_id], :page => page_number, :per_page => items_per_page) || nil rescue nil
  #     end
  #   elsif data_source_id
  #     name_strings = self.paginate_by_sql(["select ns.id, ns.name from canonical_forms cf join name_strings ns on (cf.id = ns.canonical_form_id) join name_indices ni on (ns.id = ni.name_string_id) where cf.name like ?  and ni.data_source_id = ? order by ns.name", search_term, data_source_id], :page => page_number, :per_page => items_per_page) || nil rescue nil
  #     if name_strings.blank?
  #       name_strings = self.paginate_by_sql(["select n.id, n.name from name_strings n join name_indices i on (n.id = i.name_string_id) where n.name like ? and i.data_source_id = ? order by n.name", search_term, data_source_id], :page => page_number, :per_page => items_per_page) || nil rescue nil
  #     end
  #   else
  #     name_strings = self.paginate_by_sql(["select ns.id, ns.name from canonical_forms cf join name_strings ns on (cf.id = ns.canonical_form_id) where cf.name like ? order by ns.name", search_term], :page => page_number, :per_page => items_per_page) || nil rescue nil
  #     if name_strings.blank?
  #       name_strings = self.paginate_by_sql(["select id, name from name_strings where name like ? order by name", search_term], :page => page_number, :per_page => items_per_page) || nil rescue nil
  #     end
  #   end
  #   name_strings
  # end

  def self.delete_orphans()
    orphans = ActiveRecord::Base.connection.select_values("select ns.id from name_strings ns left join name_indices ni on ns.id = ni.name_string_id where name_string_id is null").join(",")
    ActiveRecord::Base.connection.execute("delete from name_strings where id in (#{orphans})") unless orphans.blank?
  end
end
