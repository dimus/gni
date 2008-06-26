class DataSource < ActiveRecord::Base
  has_many :data_providers
  has_many :access_rules
  has_many :name_indecies
  belongs_to :uri_type
  belongs_to :response_format
  
  validates_presence_of :title, :message => "can't be blank"
  validates_presence_of :data_url, :message => "can't be blank"
  validates_format_of :data_url, :with => /^https?:\/\//, :message => "is invalid"
end
