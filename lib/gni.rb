require 'net/http'
require 'uri'
# A namesplace to keep project-specific data

module GNI
  module Encoding
    UTF8RGX = /\A(
        [\x09\x0A\x0D\x20-\x7E]            # ASCII
      | [\xC2-\xDF][\x80-\xBF]             # non-overlong 2-byte
      |  \xE0[\xA0-\xBF][\x80-\xBF]        # excluding overlongs
      | [\xE1-\xEC\xEE\xEF][\x80-\xBF]{2}  # straight 3-byte
      |  \xED[\x80-\x9F][\x80-\xBF]        # excluding surrogates
      |  \xF0[\x90-\xBF][\x80-\xBF]{2}     # planes 1-3
      | [\xF1-\xF3][\x80-\xBF]{3}          # planes 4-15
      |  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
    )*\z/x unless defined? UTF8RGX
  
    def self.utf8_file?(fileName)
      count = 0
      File.open("#{fileName}").each do |l|
        count += 1
        unless utf8_string?(l)
          puts count.to_s + ": " + l
        end
      end
      return true
    end
  
    def self.utf8_string?(a_string)
      UTF8RGX === a_string
    end

  end
  
  module Image
    require 'rubygems'
    require 'RMagick'
    
    def self.logo_thumbnails(img_url,data_source_id)
      success = true
      return false if img_url.blank?
      begin
        img = Magick::Image.read(img_url).first
        [['large','150x100'],['medium','75x50'],['small','50x25']].each do |size|
          img.change_geometry(size[1]) {|cols,rows,img| tm = img.resize(cols,rows).write(RAILS_ROOT + '/public/images/logos/' + data_source_id.to_s + '_' + size[0] + '.jpg')}      
        end
      rescue #Magick::ImageMagickError
        success = false
      end
      success
    end
  end
  
  
  class Url
    
    attr_reader :net_http, :path, :header
    
    def initialize(url)
      @url = url
      @parsed_url = URI.parse(url.strip)
      @path = @parsed_url.path == '' ? '/' : @parsed_url.path
      @net_http = Net::HTTP.new(@parsed_url.host, @parsed_url.port)
      @header = get_header
    end
   
    # confirm that the passed in URL is valid and responses with a proper code
    def valid?
        @header && ['200','301','302'].include?(@header.code)
    end
  
    def content_length
      header ? header.content_length : nil
    end

  protected
    def get_header
      begin
        return @net_http.head(@path) 
      rescue SocketError 
        return nil
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
        yield percentage, elapsed_time, eta
      end
    end
    protected
  
    def calculate_eta(percentage, elapsed_time)
      eta = elapsed_time/percentage * 100 - elapsed_time
      eta = 1.0 if eta <= 0
      eta
    end
  end
  
end