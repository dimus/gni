class LexicalGroupNameString < ActiveRecord::Base
  belongs_to :name_string
  belongs_to :lexical_group
end
