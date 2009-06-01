require 'net/http'
require 'uri'

module ActiveRecord #:nodoc:
  class Base
    def self.gni_sanitize_sql(ary)
      self.sanitize_sql_array(ary)
    end
  end
end

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
    
    def self.logo_thumbnails(data_source)
      img_url = data_source.logo_url
      success = true
      return false if img_url.blank?
      begin
        img = Magick::Image.read(img_url).first
        [['large','150x100'],['medium','75x50'],['small','50x25']].each do |size|
          img.change_geometry(size[1]) {|cols,rows,img| tm = img.resize(cols,rows).write(data_source.logo_path + data_source.id.to_s + '_' + size[0] + '.jpg')}      
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

end