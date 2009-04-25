require 'net/http'
require 'uri'

class GniUrl
   
# confirm the passed in URL is valid and responses with a proper code
  def self.valid_url?(url)
      head = self.header(url) 
      head && ['200','301','302'].include?(head.code)
  end
  
  def self.header(url)
    begin
      parsed_url=URI.parse(url.strip)
      return Net::HTTP.new(parsed_url.host,parsed_url.port).head(parsed_url.path == '' ? '/' : parsed_url.path)
    rescue
      return nil
    end
  end

end
