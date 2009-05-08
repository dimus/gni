module GNI
  DOWNLOAD_PATH = RAILS_ROOT + "/repositories/"
  
  class HarvestError < RuntimeError
    def report_error(an_import_scheduler)
      an_import_scheduler.status = ImportScheduler::FAILED
      an_import_scheduler.message = ActiveRecord::Base.gni_sanitize_sql ["%s", self.message]
      an_import_scheduler.save!
    end
  end
  
  class HarvestScheduler
  end
  
  class DownloadScheduler
    attr_reader :downloadables
    
    def initialize
      @downloadables = ImportScheduler.downloadables
    end
    
    def que_number(data_source)
      return @downloadables.map {|is| is.data_source}.index data_source
    end
    
    def do_downloads(with_details = nil)
      while !@downloadables.blank?
        dl = @downloadables.first
        begin
          data_source = dl.data_source
          dlr = Downloader.new(data_source)
          file_name = DOWNLOAD_PATH + data_source.downloaded_file_name
          dl.change_state ImportScheduler::DOWNLOADING, "Downloading"
          if with_details
            dlr.download_with_percentage(file_name) do |r| 
              msg = sprintf("Downloaded %.0f%% in %.0f seconds ETA is %.0f seconds", r[:percentage], r[:elapsed_time], r[:eta])
              dl.change_state ImportScheduler::DOWNLOADING, msg
            end
          else
            dlr.download(file_name)
          end
          dl.change_state ImportScheduler::PREPROCESSING, "Preprocessing"
          if block_given?
            yield 0
          end
        rescue Errno::ECONNREFUSED
          dl.change_state ImportScheduler::FAILED, "Cannot establish connection with #{dl.data_source.data_url}"
        rescue URI::InvalidURIError => e
          dl.change_state ImportScheduler::FAILED, e.message
        rescue HarvestError => e
          dl.change_state ImportScheduler::FAILED, e.message
        end
        @downloadables = ImportScheduler.downloadables
      end
    end    
  end
  
  class Downloader
    
    attr_reader :url
    
    def initialize(data_source)
      @data_source = data_source
      @url = Url.new(@data_source.data_url)
      @download_length = 0
    end
    
    #downloads a given file into a specified filename. If block is given returns download progress
    def download(file_name)
      raise HarvestError, "#{@data_source.data_url} is not accessible" unless @url.valid?
      f = open(file_name,'w')
      count = 0
      @url.net_http.request_get(@url.path) do |r|
        r.read_body do |s|
          @download_length += s.length
          f.write s
          if block_given?
            count += 1
            if count % 100 == 0
              yield @download_length
            end
          end
        end 
      end
      f.close
      downloaded = @download_length
      @download_length = 0
      downloaded
    end
    
    def download_with_percentage(file_name)
      start_time = Time.now
      download(file_name) do |r| 
        percentage = r.to_f/@url.header.content_length * 100
        elapsed_time = Time.now - start_time
        eta = calculate_eta(percentage, elapsed_time)
        res = {:percentage => percentage, :elapsed_time => elapsed_time, :eta => eta}
        yield res
      end
    end
    protected
  
    def calculate_eta(percentage, elapsed_time)
      eta = elapsed_time/percentage * 100 - elapsed_time
      eta = 1.0 if eta <= 0
      eta
    end
  end
  
  class Preprocessor
    def execute
      puts 'got here'
    end
  end
  
end