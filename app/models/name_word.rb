class NameWord < ActiveRecord::Base
  has_many :name_word_semantics
  
  #takes a name string, returns array of arrays where each consist of a word position and the word
  def self.get_words(name_string)
    name = name_string
    #spaces are not removed to keep position data correct.
    name = name.gsub(/[\(\)\[\],.;|\?"'&\s]/, ' ').gsub(/ et /, '    ').gsub(/ and /, '     ') if name
    word = ''
    last_letter = ' '
    count = 0
    word_position = 0 
    words = []
    name.split('').each do |l|
      if l != ' ' && last_letter == ' '
        words << [word_position, Taxamatch::Normalizer.normalize_word(word)] if word && word != ''
        word = l
        word_position = count
      elsif l != ' '
        word += l
      end
      last_letter = l
      count += 1
    end
    words << [word_position, Taxamatch::Normalizer.normalize_word(word)]
  end

end
