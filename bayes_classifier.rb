class BayesClassifier
  attr_accessor :pos_hash_counter, :neg_hash_counter, :size_counter

  #we have the same number of pos and neg classes(priori is number_of_instances_of_class/total_number_instances_all_classes)
  POS_PRIORI = 0.5
  NEG_PRIORI = 0.5

  def initialize
    @size_counter = Hash.new
    @size_counter['pos'] ||= Hash.new(0)
    @size_counter['neg'] ||= Hash.new(0)
    @pos_hash_counter ||= Hash.new(0)
    @neg_hash_counter ||= Hash.new(0)
  end

  def get_accuracy
    positive_array = Dir.glob("#{Dir.pwd}/txt_sentoken/pos/*.txt")
    negative_array = Dir.glob("#{Dir.pwd}/txt_sentoken/neg/*.txt")

    positive_array = positive_array.sort
    negative_array = negative_array.sort

    training_pos = positive_array
    training_neg = negative_array

    train(training_pos, training_neg)

    results = []
    10.times do |i|
      test_pos = positive_array[(i*100)..(i*100+99)]
      test_neg = negative_array[(i*100)..(i*100+99)]

      train(training_pos - test_pos, training_neg - test_neg)
      correct_guesses = cross_validation(test_pos, test_neg)
      results << BigDecimal.new(correct_guesses) / (test_pos.size + test_neg.size)
    end

    results.inject{ |sum, el| sum + el }.to_f / results.size
  end

  def cross_validation(test_pos, test_neg)
    correct_validations = 0

    test_pos.each do |file|
      correct_validations += get_class(file) == 'pos' ? 1 : 0
    end

    test_neg.each do |file|
      correct_validations += get_class(file) == 'neg' ? 1 : 0
    end

    correct_validations
  end

  def train(pos_set, neg_set)
    @pos_hash_counter = compute_counter_hash(pos_set, 'pos')
    @neg_hash_counter = compute_counter_hash(neg_set, 'neg')
  end

  def compute_counter_hash(set, type)
    training_hash = Hash.new(0)

    set.each do |file|
      text = Reader.read(file)
      word_array = text.split(' ')
      @size_counter[type][:total] += word_array.size
      word_array.each do |word|
        training_hash[word] += 1
      end
    end

    training_hash
  end

  def get_class(file)
    word_count_hash = Hash.new(0)
    positive_percentage = POS_PRIORI
    negative_percentage = NEG_PRIORI

    text = Reader.read(file)
    text.split(' ').each do |word|
      word_count_hash[word] +=1
    end

    word_count_hash.keys.each do |key|
      positive_percentage *= (get_word_probability(key, 'pos') ** word_count_hash[key])
      negative_percentage *= (get_word_probability(key, 'neg') ** word_count_hash[key])
    end

    positive_percentage > negative_percentage ? 'pos' : 'neg'
  end

  def get_word_probability(key, type)
    apparitions = type == 'pos' ? @pos_hash_counter[key] : @neg_hash_counter[key]
    word_number = @size_counter[type][:total]
    different_word_number = type == 'pos' ? @pos_hash_counter.keys.count : @neg_hash_counter.keys.count

    result = (BigDecimal.new(apparitions) + 1) / (word_number + different_word_number)

    result
  end
end