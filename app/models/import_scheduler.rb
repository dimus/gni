class ImportScheduler < ActiveRecord::Base
  belongs_to :data_source

  unless defined? CONSTANTS_DEFINED
    NO_IMPORTS        = nil
    WAITING           = 1
    PROCESSING        = 2
    FAILED            = 3
    UPDATED           = 4
    UNCHANGED         = 5
    DOWNLOADING       = 6
    PREPROCESSING     = 7
    CONSTANTS_DEFINED = true
  end

  def self.current(a_data_source)
    ds_id = find_data_source_id(a_data_source)
    ImportScheduler.find_by_sql(["select * from import_schedulers where data_source_id = ? order by updated_at desc limit 1", ds_id])[0] rescue nil
  end
    
  def self.last_successful_import(a_data_source)
    ds_id = find_data_source_id(a_data_source)
    ImportScheduler.find_by_sql(["select * from import_schedulers where data_source_id = ? and status in (?,?) order by updated_at desc limit 1", ds_id, UPDATED,UNCHANGED])[0] rescue nil
  end
  
  def self.in_process?(a_data_source)
    cs = ImportScheduler.current a_data_source
    (cs && [WAITING, DOWNLOADING, PREPROCESSING, PROCESSING].include?(cs.status)) ? true : false
  end
  
  def self.downloadables
    downloadables = []
    DataSource.all.each do |ds|
      current =  ImportScheduler.current(ds)
      downloadables << current if current && current.status == WAITING 
    end 
    downloadables
  end
  
  def self.preprocessed_item
    self.find_by_status(PREPROCESSING)
  end
  
  def self.processed_item
    self.find_by_status(PROCESSING)
  end
  
  # Schedule a data_source for import if 
  # 1. it is not scheduled already
  # 2. has refresh_period_days > 0
  # 3. last successfull update happened more then refresh_period_days days ago
  def self.run_scheduler(dry_run = false)
    to_schedule = []
    DataSource.all.each do |a_data_source|
      if  !ImportScheduler.in_process?(a_data_source) && a_data_source.refresh_period_days && a_data_source.refresh_period_days > 0
      
        last_success = ImportScheduler.find_by_data_source_id(a_data_source.id, :conditions => "status = #{UPDATED}", :order => 'updated_at desc')
        if last_success == nil || (Time.now - last_success.updated_at) > (a_data_source.refresh_period_days.to_i * 60 * 60 * 24)
          if dry_run
            to_schedule << a_data_source
          else  
            ImportScheduler.create(:data_source => a_data_source, :status => WAITING, :message => "Scheduled")
          end
        end
      end
    end
    dry_run ? to_schedule : nil
  end
  
  def change_state(new_status, new_msg)
    self.status = new_status
    self.message = new_msg
    self.save!
  end
  
protected
  def self.find_data_source_id(a_data_source)
    ds_id = 0
    if a_data_source.class == DataSource 
      ds_id = a_data_source.id
    elsif a_data_source.class == Fixnum
      ds_id = a_data_source
    end
    ds_id
  end

end
