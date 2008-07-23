class NameIndexRecord < ActiveRecord::Base
  belongs_to :name_index
  belongs_to :kingdom
end
