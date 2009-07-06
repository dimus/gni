module GNI
  class NameWordsGenerator
    def initialize(transaction_limit = 200000)
      @c = ActiveRecord::Base.connection
      @names = get_names
      @names_order = nil
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
      @names.each do |name_array|
        count += 1
        
        if count % @transaction_limit == 0
          name_string_id, name, canonical_form_id = name_array
          words = NameWord.split_name(name)
          positions = @parser.parse(name).pos
          generate_words(words, positions, name_string_id)
          insert_canonical_form(name_string_id, name) unless canonical_form_id
          end_transaction
          start_transaction
        end
      end
      end_transaction
    end
      
  protected
    def get_names
      @c.execute('select ns.id, ns.name, ns.canonical_form_id where ns.has_words = 0 or ns.has_words is null')
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
    
    def generate_words(words, positions, name_string_id)
      words.each do |word|
        semantic_meaning = (positions[word[0]] ? positions[word[0]][0] : nil) rescue nil
        word << semantic_meaning
        sem_id = @semantics[word[2].to_sym] ? @semantics[word[2].to_sym] : nil rescue nil
        name_word_id = @c.select_value("select id from name_words where word = '%s'" % word[1])
        unless nw
          name_word_id = insert_name_word(word)
        end
        insert_name_word_semantics(word,name_word_id, name_string_id)
      end
    end
    
    def insert_name_word(word_array)
      #this will only be correct with ruby 1.9
      word_size = word_array[1].size
      first_letter = @c.gni_sanitize_sql(word[1][0])
      word[1] = @c.gni_sanitize_sql(word[1])
      q = "insert into name_words (word, first_letter, length, created_at, updated_at) values ('%s', '%s', %s, now(), now())" % [word[1], first_letter, word_size]
      dbh.query(q)
      @c.select_value("select last_insert_id()")
    end
  
    def insert_name_word_semantics(word_array, name_word_id, name_string_id)
      semantic_value = word_array[2].to_sym rescue ''
      semantic_meaning_id = @semantics[semantic_value] ? @semantics[semantic_value] : 'null'
      q = "insert into name_word_semantics (name_word_id, name_string_id, semantic_meaning_id, name_string_position, created_at, updated_at) values (%s, %s, %s, %s, now(), now())" % [name_word_id, name_string_id, semantic_meaning_id, word_array[0]]
      @c.execute(q)      
    end
    
  end
end