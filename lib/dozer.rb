require 'active_support'
require 'active_support/core_ext/hash'
require "dozer/version"
require 'dozer/mapperable'

module Dozer
  class Error < StandardError; end

  # transform the data from one schema to another schema.
  def self.map(hash, mapper, options={})
    mapper.transform(hash, options)
  end
end
