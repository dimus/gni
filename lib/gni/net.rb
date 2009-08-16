require 'net/http'
require 'uri'

module GNI
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