class NameString < ActiveRecord::Base
  has_one :kingdom
  has_many :name_indecies
end
