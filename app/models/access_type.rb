class AccessType < ActiveRecord::Base
  has_many :access_rules
end
