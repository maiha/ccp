require 'ccp/kvs/core'

module Ccp
  module Kvs
    NotFound = Class.new(RuntimeError)

    DICTIONARY = {}             # cache for (extname -> Kvs)

    include Enumerable
    delegate :delete, :to=>"DICTIONARY"

    def each(&block)
      DICTIONARY.each_value(&block)
    end

    def [](name)
      kvs = DICTIONARY[name.to_s] and return kvs
      name.must(Core) {
        raise NotFound, "%s(%s) for %s" % [name, name.class, DICTIONARY.keys.inspect]
      }
    end

    def []=(key, val)
      DICTIONARY[key.to_s] = val
    end

    alias :lookup :[]
    extend self
  end
end

require 'ccp/kvs/hash'

Ccp::Kvs[:hash] = Ccp::Kvs::Hash
