require 'net/http'
require 'uri'

class GnaUrl
   
# confirm the passed in URL is valid and responses with a proper code
  def self.valid_url?(url)
    valid_url = true
    begin
      parsed_url=URI.parse(url)
      header=Net::HTTP.new(parsed_url.host,parsed_url.port).head(parsed_url.path == '' ? '/' : parsed_url.path)    
      valid_url = false unless ['200','301','302'].include?(header.code) 
    rescue
      valid_url = false
    end
    valid_url
  end

end
