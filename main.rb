require './reader'
require './bayes_classifier'
require 'bundler/setup'
Bundler.require(:default)

bc = BayesClassifier.new

bc.compute_info_hash