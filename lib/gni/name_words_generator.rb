module GNI
  class NameWordsGenerator
    def initialize(transaction_limit = 10000)
      @c = ActiveRecord::Base.connection
      @names = get_names
      @names_order = nil
      @semantics = get_semantics
      @transaction_limit = transaction_limit
      @norm = Taxamatch::Normalizer
      @parser = nil
    end
    
    def names
      @names ||= get_names
    end
    
    def semantics
      @semantics ||= get_semantics 
    end
    
    def generate_words(print_progress = false)
      start_transaction
      count = 0
      names.each do |name_string_id, name, canonical_form_id|
        count += 1
        words = NameWord.get_words(name)
        parsed_name = @parser.parse(name)[:scientificName]
        positions = parsed_name[:positions] 
        canonical_form_id = insert_canonical_form(name_string_id, parsed_name[:canonical]) if canonical_form_id == nil && parsed_name[:canonical]
        generate(words, positions, name_string_id, canonical_form_id)
        if count % @transaction_limit == 0
          puts count if print_progress
          end_transaction
          start_transaction
        end
      end
      end_transaction
    end
      
  protected
    def get_names
      @c.execute('select ns.id, ns.name, ns.canonical_form_id from name_strings ns where ns.has_words = 0 or ns.has_words is null')
    end
    
    def get_semantics
      SemanticMeaning.all.inject({}) {|res, sm| res[sm.name.to_sym] = sm.id; res}
    end
    
    def start_transaction
      @c.execute('start transaction') if RAILS_ENV != 'test'
      @parser = Parser.new
    end
    
    def end_transaction
      @c.execute('commit') if RAILS_ENV != 'test'
    end
    
    def generate(words, positions, name_string_id, canonical_form_id)
      words.each do |word|
        semantic_meaning = (positions[word[0]] ? positions[word[0]][0] : nil) rescue nil
        word << semantic_meaning
        sem_id = @semantics[word[2].to_sym] ? @semantics[word[2].to_sym] : nil rescue nil
        name_word_id = @c.select_value("select id from name_words where word = '%s'" % word[1])
        unless name_word_id
          name_word_id = insert_name_word(word)
        end
        insert_name_word_semantics(word,name_word_id, name_string_id)
      end
      canonical_form_id = "'null'" unless canonical_form_id
      @c.update("update name_strings set has_words = 1, canonical_form_id = %s where id = %s" % [canonical_form_id, name_string_id])
    end
    
    def insert_name_word(word_array)
      #this will only be correct with ruby 1.9
      word_size = word_array[1].size
      first_letter = word_array[1][0..0]
      q = "insert into name_words (word, first_letter, length, created_at, updated_at) values ('%s', '%s', %s, now(), now())" % [word_array[1], first_letter, word_size]
      @c.insert(q)
    end
  
    def insert_name_word_semantics(word_array, name_word_id, name_string_id)
      semantic_value = word_array[2].to_sym rescue ''
      semantic_meaning_id = @semantics[semantic_value] ? @semantics[semantic_value] : 'null'
      q = "insert into name_word_semantics (name_word_id, name_string_id, semantic_meaning_id, name_string_position, created_at, updated_at) values (%s, %s, %s, %s, now(), now())" % [name_word_id, name_string_id, semantic_meaning_id, word_array[0]]
      @c.execute(q)
    end
    
    def insert_canonical_form(name_string_id, canonical_form)
      canonical_form = @norm.normalize canonical_form
      canonical_form_id = @c.select_value("select id from canonical_forms where name = '%s'" % canonical_form)
      unless canonical_form_id
        canonical_form_id = @c.insert("insert into canonical_forms (name, created_at, updated_at) values ('%s', now(), now())" % canonical_form)
        
        words = canonical_form.split(" ")
        word1_id = @c.select_value("select id from name_words where word = '#{words[0]}'") || 'null' rescue 'null'
        @c.execute ActiveRecord::Base.gni_sanitize_sql(["insert into extended_canonical_forms (id, number_of_words, word1_id, word1, word1_length, word2, word2_length, word3, word3_length) values (?, ?, ?, ?, ?, ?, ?, ?, ?)", canonical_form_id, words.size, word1_id, words[0], (words[0].size rescue nil), words[1], (words[1].size rescue nil), words[2], (words[2].size rescue nil)])

      end
      return canonical_form_id
    end
  end
end
