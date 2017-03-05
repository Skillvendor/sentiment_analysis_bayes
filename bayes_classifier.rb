class BayesClassifier
  attr_accessor :info_hash

  def initialize
  end

  def compute_info_hash
    Dir.glob("#{Dir.pwd}/txt_sentoken/pos/*.txt") do |txt_file|
      text = Reader.read(txt_file)
    end
  end
end