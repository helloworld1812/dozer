require "dozer/version"

module Dozer
  class Error < StandardError; end

  # mapping is the relation between two schemas.
  def self.map(hash, mapper, options={})
    mapper.call(hash, options)
  end
end
