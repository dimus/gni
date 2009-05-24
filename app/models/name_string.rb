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
    name_strings = nil
    if user_id
      name_strings = self.paginate_by_sql(["select distinct ns.id, ns.name from canonical_forms cf join name_strings ns on (cf.id = ns.canonical_form_id) join name_indices ni on (ns.id = ni.name_string_id) join data_source_contributors dsc on (ni.data_source_id = dsc.data_source_id)  where cf.name like ? and dsc.user_id = ? order by ns.name", search_term, user_id], :page => page_number, :per_page => items_per_page) || nil rescue nil
      if name_strings.blank?
        name_strings = self.paginate_by_sql(["select distinct n.id, n.name from name_strings n join name_indices i on (n.id = i.name_string_id) join data_source_contributors c on (i.data_source_id = c.data_source_id)  where n.name like ? and c.user_id = ? order by n.name", search_term, user_id], :page => page_number, :per_page => items_per_page) || nil rescue nil
      end
    elsif data_source_id
      name_strings = self.paginate_by_sql(["select ns.id, ns.name from canonical_forms cf join name_strings ns on (cf.id = ns.canonical_form_id) join name_indices ni on (ns.id = ni.name_string_id) where cf.name like ?  and ni.data_source_id = ? order by ns.name", search_term, data_source_id], :page => page_number, :per_page => items_per_page) || nil rescue nil
      if name_strings.blank?
        name_strings = self.paginate_by_sql(["select n.id, n.name from name_strings n join name_indices i on (n.id = i.name_string_id) where n.name like ? and i.data_source_id = ? order by n.name", search_term, data_source_id], :page => page_number, :per_page => items_per_page) || nil rescue nil
      end
    else
      name_strings = self.paginate_by_sql(["select ns.id, ns.name from canonical_forms cf join name_strings ns on (cf.id = ns.canonical_form_id) where cf.name like ? order by ns.name", search_term], :page => page_number, :per_page => items_per_page) || nil rescue nil
      if name_strings.blank?
        name_strings = self.paginate_by_sql(["select id, name from name_strings where name like ? order by name", search_term], :page => page_number, :per_page => items_per_page) || nil rescue nil
      end
    end
    name_strings
  end

  def self.delete_orphans()
    orphans = ActiveRecord::Base.connection.select_values("select ns.id from name_strings ns left join name_indices ni on ns.id = ni.name_string_id where name_string_id is null").join(",")
    ActiveRecord::Base.connection.execute("delete from name_strings where id in (#{orphans})") unless orphans.blank?
  end
end
