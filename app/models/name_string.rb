class NameString < ActiveRecord::Base
  has_one :kingdom
  has_many :name_indices
  has_many :data_source_import_details
  has_many :data_sources, :through => :name_indices
  
  LATIN_CHARS = ('A'..'Z')
  
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
