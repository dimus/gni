module GNI::Spec
  module Helpers
  end
end

class ActiveRecord::Base

# truncate's this model's table
  def self.truncate
    connection.execute "TRUNCATE TABLE #{ table_name }"
  rescue => ex
    puts "#{ self.name }.truncate failed ... does the table exist?  #{ ex }"
  end
end
