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
end