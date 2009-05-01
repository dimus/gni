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
end