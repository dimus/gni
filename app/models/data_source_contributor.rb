class DataSourceContributor < ActiveRecord::Base
  belongs_to :data_source
  belongs_to :user
  
  validates_presence_of :data_source_id, :user_id, :message => "should be set"
end
