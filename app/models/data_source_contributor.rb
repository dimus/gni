class DataSourceContributor < ActiveRecord::Base
  belongs_to :data_source
  belongs_to :user
  
  validates_presence_of :user, :message => "should be set"
  validates_presence_of :data_source, :message => "should be set"
end
