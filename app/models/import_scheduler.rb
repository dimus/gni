class ImportScheduler < ActiveRecord::Base
  belongs_to :data_source
  
  NO_IMPORTS = nil
  WAITING = 1
  PROCESSING = 2
  FAILED = 3
  UPDATED = 4

  def self.current_status(a_data_source)
    ds_id = 0
    if a_data_source.class == DataSource 
      ds_id = a_data_source.id
    elsif a_data_source.class == Fixnum
      ds_id = a_data_source
    end
    ImportScheduler.find_by_sql(["select status from import_schedulers where data_source_id = ? order by updated_at desc limit 1", ds_id])[0].status rescue nil
  end

  def self.scheduled?(a_data_source)
    cs = ImportScheduler.current_status a_data_source
    if cs == WAITING || cs == PROCESSING
      return true
    end
    return false
  end
end
