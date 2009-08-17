module GNI
  module ParserResult
    def parsed=(parsed)
      @parsed = parsed
    end
    
    def parsed
      return @parsed
    end
    
    #by some reason Rails does not generate clean json, so if possible it is generated in parser
    def format_json
      self.parsed ? self.parsed.all_json : self.to_json
    end
    
    def format_html
       Parser.render_html self
    end
    
    def format_xml
      GNI::XML::XML_HEAD + "<scientific_name>\n" + Parser.traverse(self,1) + "</scientific_name>\n"
    end
  end
end