class ImportScheduler < ActiveRecord::Base
  belongs_to :data_source

  unless defined? CONSTANTS_DEFINED
    NO_IMPORTS  = nil
    WAITING     = 1
    DOWNLOADING = 2
    PROCESSING  = 3
    FAILED      = 4
    UPDATED     = 5
    UNCHANGED   = 6
    CONSTANTS_DEFINED = true
  end

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
  
  def self.data_sources_to_schedule()
    dss = []
    DataSource.all.each do |ds|
      dss << ds if ImportScheduler.ready_to_schedule?(ds)
    end 
    dss
  end
  
  # Schedule a data_source for import if 
  # 1. it is not scheduled already
  # 2. has refresh_period_days > 0
  # 3. last successfull update happened more then refresh_period_days days ago
  def self.ready_to_schedule?(a_data_source)
    is_ready = false
    if  !ImportScheduler.scheduled?(a_data_source) && a_data_source.refresh_period_days && a_data_source.refresh_period_days > 0
      
      last_success = ImportScheduler.find_by_data_source_id(a_data_source.id, :conditions => "status = #{UPDATED}", :order => 'updated_at desc')
      if last_success == nil || (Time.now - last_success.updated_at) > (a_data_source.refresh_period_days.to_i * 60 * 60 * 24)
        is_ready = true
      end
    end
    is_ready
  end
end
