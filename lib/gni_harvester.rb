require 'nokogiri'
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
          file_name = data_source.file_path
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
      return false unless RAILS_ENV == 'production'
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
        @file_processor = FileProcessorFactory.new(@preprocessed_item.data_source).file_processor
        @file_processor.process do |state| 
          @preprocessed_item.change_state state[0], state[1]
          yield state[0]
        end
        @preprocessed_item = ImportScheduler.preprocessed_item
      end
    end
  end
  
  class FileProcessorFactory
    attr_reader :file_processor
    
    def initialize(data_source)
      @data_source = data_source
      set_file_processor
    end

    protected
    
    def set_file_processor
      file_type = IO.popen("file " + @data_source.file_path).read
      ['Zip', 'HTML', 'XML'].each do |x|
        if file_type.match /#{x}/i
          eval("@file_processor = Processor#{x}.new(@data_source)")
          break
        end
      end
      @file_processor ||= ProcessorNull.new(@data_source)
    end
    
    
    class ProcessorFile
      def initialize(data_source)
        @data_source = data_source
      end
      def process
        raise RuntimeException, "Not implemented"
      end
    end
    
    class ProcessorXML < ProcessorFile
      def process
        FileUtils.mkdir_p @data_source.directory_path
        FileUtils.mv @data_source.file_path, @data_source.directory_path
        yield [ImportScheduler::PROCESSING, "Processing"]
      end
    end
    
    class ProcessorHTML < ProcessorFile
      def process
        File.unlink(@data_source.file_path)
        yield [ImportScheduler::FAILED, "Got HTML file instead of data file (404 error?)"]
      end
    end
    
    class ProcessorZip < ProcessorFile
      def process
        FileUtils.rm_rf @data_source.temporary_path
        system "unzip -d #{@data_source.temporary_path} #{@data_source.file_path}"
        dwc = ProcessorDarwinCoreStar.new(@data_source)
        dwc.process {|status| yield status}
      end
    end

    class ProcessorDarwinCoreStar < ProcessorFile
      def process
        unless File.exists? @data_source.temporary_path
           yield [ImportScheduler::FAILED, "Looks like download of compressed file was interrupted, or archive is not compressed correctly"]
        end
        Dir.chdir @data_source.temporary_path
        entries =  Dir.entries "."

        if entries.include?('meta.xml')
          Dir.chdir DOWNLOAD_PATH
          FileUtils.rm_rf @data_source.directory_path
          system "mv #{@data_source.temporary_path} #{@data_source.directory_path}"
        else
          entries.select {|ent| ent != '.' && ent != '..'}.each do |entry|
            if File.directory?(entry) && Dir.entries(entry).include?('meta.xml')
              FileUtils.rm_rf @data_source.directory_path
              system "mv #{entry} #{@data_source.directory_path}"
              dwcc = DwcToTcsConverter.new(@data_source)
              current_state = dwcc.convert ? [ImportScheduler::PROCESSING, "Processing"] : [ImportScheduler::FAILED, "Cannot convert Darwin Core Star files to Taxon Concept Schema XML"]
              yield current_state
              clean_up
              return
            end
          end
          yield [ImportScheduler::FAILED, "Cannot find DarwinCore Star Files"]
          clean_up
        end
      end
      
      protected
      
      def clean_up
        File.unlink @data_source.file_path
        FileUtils.rm_rf @data_source.temporary_path
      end
    end
    
    class ProcessorNull < ProcessorFile
      def process
        msg = File.exists?(@data_source.file_path) ? "Downloaded file disappeared, some hungry file eater ate it." : "Unknown format of the file"
       yield [ImportScheduler::FAILED, msg]
      end
    end
  end
  
  
  class DwcToTcsConverter
    unless defined? CONSTANTS_DEFINED
      #terms are in low case to compensate for possible case mistakes from submitters
      CORE_TERMS_DICT  = { "http://purl.org/dc/terms/identifier" => "dc:identifier",
                      "http://purl.org/dc/terms/source"  => "dc:source",
                      "http://rs.tdwg.org/dwc/terms/scientificname" => "dwc:ScientificName",
                      "http://rs.tdwg.org/dwc/terms/taxonrank" => "dwc:TaxonRank",
                      "http://rs.tdwg.org/dwc/terms/NomenclaturalCode" => "dwc:NomenclaturalCode",
                      "http://rs.tdwg.org/dwc/terms/kingdom" => "dwc:Kingdom",
                      "http://purl.org/dc/terms/modified" => "dc:modified"}
      LINK_TERMS_DICT = { "http://purl.org/dc/terms/source"  => "dc:source",
                        "http://purl.org/dc/terms/format" => "dc:format" }
      CORE_TERMS = CORE_TERMS_DICT.keys
      LINK_TERMS = LINK_TERMS_DICT.keys
      CONSTANTS_DEFINED = true
    end
    
    def initialize(data_source)
      @data_source = data_source
      Dir.chdir @data_source.directory_path
      @core_errors = []
      @core_data = {}
    end
    
    def convert
      success = read_meta_xml
      success = ingest_core_file if success
      ingest_extensions if success
      write_tcs_xml if success
    end
    
    protected
    def read_meta_xml
      @doc = Nokogiri::XML(open 'meta.xml')
      @core = @doc.xpath('//xmlns:core').first
      @core_id = @core.xpath('child::xmlns:id').first
      @core_fields = @doc.xpath('//xmlns:core/xmlns:field').select do |f| 
        CORE_TERMS.include? f.attributes['term'].value.to_s.strip.downcase
      end
      @extensions = @doc.xpath('//xmlns:extension')
      !@core_fields.blank?
    end
    
    def ingest_core_file
      process_data(@core, @core_id, @core_fields, CORE_TERMS_DICT) do |data|
        @core_data[data[:key]] = data[:value]
      end
      !@core_data.blank?
    end
    
    def ingest_extensions
      @extensions.each do |extension|
        source_field = extension.xpath('child::xmlns:field').select {|field| field.attributes['term'].value.to_str.downcase == 'http://purl.org/dc/terms/source' }
        core_id = extension.xpath('child::xmlns:coreid').first        
        if source_field.size > 0 && core_id
          fields = extension.xpath('child::xmlns:field').select {|field| LINK_TERMS.include? field.attributes['term'].value.to_str.downcase}
          process_data(extension, core_id, fields, LINK_TERMS_DICT) do |data|
            if guid?(data[:value]['dc:source'])
              @core_data[data[:key]]['dwc:GlobalUniqueIdentifier'] = data[:value]['dc:source'] if @core_data[data[:key]]
            end
          end
        end
      end
    end

    def process_data(node, core_id, fields, terms_dict)
      return if node.blank? || core_id.blank? || fields.blank?
      delimiter = get_delimiter(node.attributes['fieldsTerminatedBy'].value)
      border_chars = node.attributes['fieldsEnclosedBy'].value || ""
      border_regex = border_chars == "" ? nil : /^#{border_chars}(.*)#{border_chars}$/
      open(node.attributes['location'].value).each do |line|
        if GNI::Encoding.utf8_string? line
          line_fields = line.split(delimiter)
          row_id = line_fields[core_id.attributes['index'].value.to_i].to_sym
          data = {:key => row_id, :value => {}}
          
          fields.each do |field|
            field_index = field.attributes['index'].value.to_i
            field_data = line_fields[field_index]
            unless field_data
              add_to_errors(line + ' -- either split by delimiter ' + delimiter + ' did not work, or wrong number of fields')
              break
            end
            field_data = field_data.gsub(border_regex, "#{$1}") if border_regex
            data[:value][terms_dict[field.attributes['term'].value.to_s.strip.downcase]] = field_data.to_s
          end
          
          yield data
        else
          add_to_errors(line.strip + " -- is not in UTF-8 encoding")
        end
      end
    end
    
    def write_tcs_xml
      xg = GNA_XML::TcsXmlBuilder.new(@data_source)
      count = 0
      @core_data.each do |key,data|
        count += 1
        xg.make_node(data, count)
      end
      xg.close
      true
    end
    
    def get_delimiter(delimiter_string)
      if delimiter_string.match /\s*\\t\s*/
        return "\t"
      elsif delimiter_string.match /\s*[\,\|]\s*/
        return delmiter_string.strip
      elsif delmiter_string == ' '
        return ' '
      end
      delimiter_string
    end

    def guid?(a_string)
      !!(!a_string.blank? && a_string.match(/urn:lsid/))
    end
    
    def add_to_errors(error_desc)
      @core_errors << error_desc if @core_errors.size < 100
      @core_errors.size < 100
    end
  end
  
end