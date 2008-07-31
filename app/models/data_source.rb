class DataSource < ActiveRecord::Base
  has_many :data_providers
  has_many :access_rules
  has_many :data_source_imports
  has_many :name_indices
  has_many :import_schedulers
  has_many :data_source_contributors
  has_many :users, :through  =>  :data_source_contributors
  belongs_to :uri_type
  belongs_to :response_format
  
  validates_presence_of :title, :message => "can't be blank"
  validates_presence_of :data_url, :message => "can't be blank"
  validates_format_of :data_url, :with => /^https?:\/\//, :message => "is invalid"
  
  def contributor?(a_user)
    !!self.users.include?(a_user)
  end
end
