module GNI
  class NameWordsGenerator
    def initialize(transaction_limit = 200000)
      @c = ActiveRecord::Base.connection
      @names = get_names
      @semantics = get_semantics
      @transaction_limit = transaction_limit
      @parser = nil
    end
    
    def names
      @names
    end
    
    def semantics
      @semantics
    end
    
    def generate_words
      start_transaction
      count = 0
      @names.each do |name|
        count += 1
        if count % @transaction_limit == 0
          end_transaction
          start_transaction
        end
      end
      end_transaction
    end
      
  protected
    def get_names
      @c.execute('select ns.id, ns.name, ns.canonical_form_id, cf.name from name_strings ns left join canonical_forms cf on cf.id = ns.canonical_form_id where ns.has_words = 0 or ns.has_words is null')
    end
    
    def get_semantics
      SemanticMeaning.all.inject({}) {|res, sm| res[sm.name.to_sym] = sm.id; res}
    end
    
    def start_transaction
      @c.execute('start_transaction') if RAILS_ENV != 'test'
      @parser = Parser.new
    end
    
    def end_transaction
      @c.execute('commit') if RAILS_ENV != 'test'
    end
  end
  
end