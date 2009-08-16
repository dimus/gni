require 'RMagick'

module GNI
  module Image    
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
end