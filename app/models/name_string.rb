class NameString < ActiveRecord::Base
  has_one :kingdom
  has_many :name_indices
  has_many :data_source_import_details
  has_many :data_sources, :through => :name_indices
  
  LATIN_CHARS = ('A'..'Z')
  
  def self.normalize_name_string(n_string)
    del_chars = /[.;,]/
    space_char = /([-\(\)\[\]\{\}:&?\*])/
    mult_spaces = /\s{2,}/
    n_string = n_string.gsub(del_chars,' ')
    n_string = n_string.gsub(space_char,' \1 ')
    n_string.gsub(mult_spaces, ' ').strip
  end
  
  def self.char_triples(latin_char)
    triples = []
    LATIN_CHARS.each do |c1|
      triples_array = []
      LATIN_CHARS.each do |c2|
        triples_array << latin_char + c1 + c2
      end
      triples << triples_array
    end
    triples
  end

end
