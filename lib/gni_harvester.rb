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
          file_name = DOWNLOAD_PATH + data_source.id.to_s
          dl.change_state ImportScheduler::DOWNLOADING, "Downloading"
          if with_details
            dlr.download_with_percentage(file_name) do |r| 
              msg = sprintf("Downloaded %.0f%% in %.0f seconds ETA is %.0f seconds", r[:percentage], r[:elapsed_time], r[:eta])
              dl.change_state ImportScheduler::DOWNLOADING, msg
            end
          else
            dlr.download(file_name)
          end
          current_state = dlr.unchanged? ? [ImportScheduler::UNCHANGED, "Unchanged"] : [ImportScheduler::PREPROCESSING, "Preprocessing"] 
          dl.change_state current_state[0], current_state[1]
          if block_given?
            yield dl.status
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
      @filename = nil
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
    
    def download_with_percentage(filename)
      @filename = filename
      start_time = Time.now
      download(@filename) do |r| 
        percentage = r.to_f/@url.header.content_length * 100
        elapsed_time = Time.now - start_time
        eta = calculate_eta(percentage, elapsed_time)
        res = {:percentage => percentage, :elapsed_time => elapsed_time, :eta => eta}
        yield res
      end
    end
    
    def unchanged?
      return false
      return nil unless (@filename && File.exists?(@filename))
      sha = IO.popen("sha1sum " + @filename).read.split(/\s+/)[0]
      if @data_source.data_hash != sha
        @data_source.data_hash = sha
        @data_source.save!
        return false
      else
        return true
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
    def initialize()
      @preprocessed_item = ImportScheduler.preprocessed_item
    end
    
     
    
    def do_preprocessing
      while @preprocessed_item     
        @file_processor = FileProcessorFactory.new(@preprocessed_item).file_processor
        @file_processor.process
        @preprocessed_item = ImportScheduler.preprocessed_item
      end
    end
  end
  
  class FileProcessorFactory
    attr_reader :file_processor
    
    def initialize(import_scheduler_item)
      @import_scheduler_item = import_scheduler_item
      @data_source_file = DOWNLOAD_PATH + @import_scheduler_item.data_source.id.to_s
      set_file_processor
    end

    protected
    
    def set_file_processor
      puts 'got here'
      file_type = IO.popen("file " + @data_source_file).read
      ['Zip', 'HTML'].each do |x|
        eval("@file_processor = Processor#{x}.new(@import_scheduler_item)") if file_type.match /#{x}/i
      end
      @file_processor ||= ProcessorNull.new(@import_scheduler_item)
    end
    
    class ProcessorHTML
      def initialize(import_scheduler_item)
        @import_scheduler_item = import_scheduler_item
        @data_file = DOWNLOAD_PATH + @import_scheduler_item.data_source.id.to_s
      end
      
      def process
        File.unlink @data_file
        @import_scheduler_item.change_state ImportScheduler::FAILED, "Got HTML file instead of data file (404 error?)"
      end
    end
    
    class ProcessorZip
      def initialize(import_scheduler_item)
        @import_scheduler_item = import_scheduler_item
        @data_file = DOWNLOAD_PATH + @import_scheduler_item.data_source.id.to_s
      end
      
      def process
        File.unlink @data_file
        @import_scheduler_item.change_state ImportScheduler::PROCESSING, "Processing"
      end
    end
    
    class ProcessorNull
      def initialize(import_scheduler_item)
        @import_scheduler_item = import_scheduler_item
        @data_file = DOWNLOAD_PATH + @import_scheduler_item.data_source.id.to_s
      end
      
      def process
        msg = File.exists?(@data_file) ? "Downloaded file diappeared, some hungry file eater ate it." : "Unknown format of the file"
        @import_scheduler_item.change_state ImportScheduler::FAILED, msg
      end
    end
  end
  
end