require './reader'
require './bayes_classifier'
require 'bigdecimal'
require 'bundler/setup'
Bundler.require(:default)

bc = BayesClassifier.new

puts bc.get_accuracy