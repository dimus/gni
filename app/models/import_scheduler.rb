class ImportScheduler < ActiveRecord::Base
  belongs_to :data_source

  WAITING = 1
  PROCESSING = 2
  FAILED = 3
  UPDATED = 4
end
