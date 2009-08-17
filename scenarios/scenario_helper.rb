
def generate_scenario(data)
  data.keys.each do |klass_name|
    klass = Object.const_get(klass_name)
    klass.truncate
    data[klass_name].each do |args|
      klass.gen(args)
    end
  end
end

def populate_name_word_semantic_table
  semantics = {:uninomial => 1, :genus => 2, :species => 3, :infraspecies => 4, :author_word => 5, :year => 6}

  parser = Parser.new
  NameWordSemantic.truncate
  NameString.all.each do |ns|
    name =  ns.name
    pos = parser.parse(name)[:scientificName][:positions]
    name = name.gsub(/[\(\)\[\],.&]/, ' ').gsub(/\s/, ' ').gsub(/ (et|and) /, ' ') if name
    word = ''
    last_letter = ' '
    count = 0
    word_position = 0 
    words = []
    name.split('').each do |l|
      if l != ' ' && last_letter == ' '
        words << [word_position, word] if word != ''
        word = l
        word_position = count
      elsif l != ' '
        word += l
      end
      last_letter = l
      count += 1
    end
    words << [word_position, word]    
    words.each do |word|
      semantic_meaning = (pos[word[0]] ? pos[word[0]][0] : nil) rescue nil
      word << semantic_meaning
      sem_id = semantics[word[2].to_sym] ? semantics[word[2].to_sym] : nil rescue nil
      nw = NameWord.find_by_word(word[1])
      puts word[1] if nw == nil
      NameWordSemantic.create(:name_word_id => nw.id, :name_string_id => ns.id, :semantic_meaning_id => sem_id, :name_string_position => word[0])
    end
  end
end


def downloaded_file(file_name, data_source)
  FileUtils.rm_rf data_source.temporary_path
  FileUtils.rm_rf data_source.directory_path
  FileUtils.mkdir data_source.temporary_path
  FileUtils.cp RAILS_ROOT + '/scenarios/files/' + file_name, data_source.file_path
end
