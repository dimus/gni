class NameWordSemantic < ActiveRecord::Base
  belongs_to :semantic_meaning
  belongs_to :name_word
end
