class DataSource < ActiveRecord::Base
  has_many :data_providers
  has_many :access_rules
  has_many :data_source_imports
  has_many :name_indices
  has_many :import_schedulers
  has_many :data_source_contributors
  has_many :users, :through  =>  :data_source_contributors
  has_many :name_strings, :through => :name_indices
  belongs_to :uri_type
  belongs_to :response_format

  URL_RE = /^https?:\/\/|^\s*$/
  
  validates_presence_of :title, :message => "is required"
  validates_presence_of :data_url, :message => "^Names Data URL is required"
  validates_format_of :data_url, :with => URL_RE, :message => "^Names Data URL should be a URL"
  validates_format_of :metadata_url, :with => URL_RE, :message => "^Metata URL should be a URL"
  validates_format_of :logo_url, :with => URL_RE, :message => "^Logo URL should be a URL"
  validates_format_of :web_site_url, :with => URL_RE, :message => "^Website URL should be a URL"
  
  def contributor?(a_user)
    !!self.users.include?(a_user)
  end

end
