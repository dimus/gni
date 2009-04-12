class DataSource < ActiveRecord::Base
  has_many :data_providers
  has_many :access_rules
  has_many :data_source_imports
  has_many :name_indices, :dependent => :destroy
  has_many :import_schedulers
  has_many :data_source_contributors, :dependent => :destroy
  has_many :users, :through  =>  :data_source_contributors
  has_many :name_strings, :through => :name_indices
  has_many :name_index_records, :through => :name_indices
  belongs_to :uri_type
  belongs_to :response_format

  URL_RE = /^https?:\/\/|^\s*$/ unless defined? URL_RE
  before_validation :prepare_urls
  before_destroy :cleanup
  
  validates_presence_of :title, :message => "is required"
  validates_presence_of :data_url, :message => "^Names Data URL is required"
  validates_format_of :data_url, :with => URL_RE, :message => "^Names Data URL should be a URL"
  validates_format_of :logo_url, :with => URL_RE, :message => "^Logo URL should be a URL"
  validates_format_of :web_site_url, :with => URL_RE, :message => "^Website URL should be a URL"
  validates_uniqueness_of :title, :data_url
  
  def contributor?(a_user)
    !!self.users.include?(a_user)
  end
  
  private
  
  def prepare_urls()
    
    self.data_url.strip! if self.data_url
    self.logo_url.strip! if self.logo_url
    self.web_site_url.strip! if self.web_site_url
  end
  
  private
  def cleanup
    ActiveRecord::Base.connection.execute("delete from data_source_overlaps where data_source_id_1 = #{self.id} or data_source_id_2 = #{self.id}")
  end
end
