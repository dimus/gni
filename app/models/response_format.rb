class ResponseFormat < ActiveRecord::Base
  has_many :data_sources
  has_many :name_indecies
end
