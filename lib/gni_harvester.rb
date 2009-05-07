module GNI
  class HarvestScheduler
    def initialize 
  end
  
  class DownloadScheduler
    attr_reader :downloadables
    
    def initialize
      @downloadables = ImportScheduler.find_by_sql("select data_source_id from import_schedulers where status = 1 order by updated_at desc")
    end
    
    def que_number(data_source)
      return @downloadables.index data_source.id + 1
    end
    
    def do_downloads(with_details = nil)
      @downloadables.each do |dl|
        Downloader.new(DataSource.find(dl.data_source_id))
      end
    end
  end
end