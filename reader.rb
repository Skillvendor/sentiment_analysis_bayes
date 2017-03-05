require 'lingua/stemmer'

class Reader
  def self.read(txt_file, delete_punctiation=true, delete_stopwords=true, use_stemmer=true)
    txt_content = File.open(txt_file, 'rb').read

    txt_content = remove_punctuation(txt_content) if delete_punctiation
    txt_content = remove_stopwords(txt_content) if delete_stopwords
    txt_content = stem_text(txt_content) if use_stemmer
  end

  def self.remove_stopwords(string)
    filter = Stopwords::Snowball::Filter.new "en"

    result = filter.filter string.split(' ')

    result.join(' ')
  end

  def self.stem_text(string)
    stemmed_words = []
    stemmer = Lingua::Stemmer.new(language: 'en')
    string.split(' ').each do |word|
      stemmed_words << stemmer.stem(word)
    end

    stemmed_words.join(' ')
  end

  def self.remove_punctuation(string)
    string.gsub(/[^a-z0-9\s]/i, '')
  end
end