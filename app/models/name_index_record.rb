class NameIndexRecord < ActiveRecord::Base
  belongs_to :name_index
  belongs_to :kingdom
  belongs_to :name_rank
end
