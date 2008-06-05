class Kingdom < ActiveRecord::Base
  has_many :name_indecies
  belongs_to :name_string
end
