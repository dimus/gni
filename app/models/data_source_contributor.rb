class DataSourceContributor < ActiveRecord::Base
  belongs_to :data_source
  belongs_to :user
  
  validates_presence_of :data_source, :user, :message => "should be set"
end
