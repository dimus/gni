module GNI
  class NameWordsGenerator
    def initialize(all = false)
      @c = ActiveRecord::Base.connection
      @names = all ? get_all_names : get_names_without_words
      @semantcis = get_semantics
    end
    
    def names
      @names
    end
    
    def semantics
      @semantics
    end
    
    
    
    
  protected
    def get_all_names
      @c.execute('select id, name from name_strings')
    end
    
    def get_names_without_words
      @c.execute('select id, name from name_strings where has_words != 1')
    end
    
    def get_semantics
      @c.select('select * from semantic_meanings').inject({}) {|res,row| res[row[:name]] = res[row[:id]]}
    end
  end
  
end