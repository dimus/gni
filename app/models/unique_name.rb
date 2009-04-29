class UniqueName < ActiveRecord::Base
  belongs_to :data_source
  belongs_to :name_string
  
  def self.update_unique_names
    ActiveRecord::Base.connection.transaction do
      ActiveRecord::Base.connection.execute("delete from unique_names");
      ActiveRecord::Base.connection.execute("insert into unique_names (select null, data_source_id, name_string_id, now(), now() from name_indices group by name_string_id having count(*) = 1)");    
    end
  end
  
end
