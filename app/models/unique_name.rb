class UniqueName < ActiveRecord::Base
  belongs_to :data_source
  belongs_to :name_string
  
  def self.update_unique_names
    ActiveRecord::Base.connection.execute("insert into unique_names select data_source_id, name_string_id from name_indices group by name_string_id having count(*) = 1") 
  end
  
  def self.uniqe_names(a_data_source_id)
    
  end
end
