# A namesplace to keep project-specific data

module GNI
  
  def self.utf8_file?(fileName)
    utf8rgx = /\A(
        [\x09\x0A\x0D\x20-\x7E]            # ASCII
      | [\xC2-\xDF][\x80-\xBF]             # non-overlong 2-byte
      |  \xE0[\xA0-\xBF][\x80-\xBF]        # excluding overlongs
      | [\xE1-\xEC\xEE\xEF][\x80-\xBF]{2}  # straight 3-byte
      |  \xED[\x80-\x9F][\x80-\xBF]        # excluding surrogates
      |  \xF0[\x90-\xBF][\x80-\xBF]{2}     # planes 1-3
      | [\xF1-\xF3][\x80-\xBF]{3}          # planes 4-15
      |  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
    )*\z/x
    str=""
    limit = 10
    count = 0
    File.open("#{fileName}").each do |l|
      count += 1
      str << l
      if count % limit == 0 
        puts count if count % 100000 == 0
        unless utf8rgx === str
          puts count
          return false
        end
        str = ""
      end
    end
    return false unless utf8rgx === str
    return true
  end
  
end