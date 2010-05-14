class UniqueName < ActiveRecord::Base
  belongs_to :data_source
  belongs_to :name_string
  
  def self.update_unique_names
    ActiveRecord::Base.connection.transaction do
      ActiveRecord::Base.connection.execute("drop table if exists tmp_unique_names");
      ActiveRecord::Base.connection.execute("create table tmp_unique_names like unique_names");
      ActiveRecord::Base.connection.execute("insert into tmp_unique_names (select null, data_source_id, name_string_id, now(), now() from name_indices group by name_string_id having count(*) = 1)");    
      ActiveRecord::Base.connection.execute("rename table tmp_unique_names to unique_names");
      ActiveRecord::Base.connection.execute("rename table unique_names to old_unique_names");
      ActiveRecord::Base.connection.execute("drop table if exists old_unique_names");
    end
  end
  
end
