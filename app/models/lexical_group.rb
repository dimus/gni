class LexicalGroup < ActiveRecord::Base
  has_many :lexical_group_name_strings
  has_many :name_strings, :through => :lexical_group_name_strings
end
