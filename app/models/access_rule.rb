class AccessRule < ActiveRecord::Base
  belongs_to :data_source
  belongs_to :access_type
end
