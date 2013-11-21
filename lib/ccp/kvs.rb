require 'ccp/kvs/core'

module Ccp
  module Kvs
    Error        = Class.new(RuntimeError)
    NotFound     = Class.new(Error)
    NotConnected = Class.new(Error)
    NotAllowed   = Class.new(Error)
    IOError      = Class.new(Error)

    DICTIONARY = {}             # cache for (extname -> Kvs)

    def self.load(path)
      array = path.to_s.split(".")
      kvs   = Ccp::Kvs[array.pop].new(path)
      codec = Ccp::Serializers[array.pop]
      kvs.codec!(codec)
      return kvs
    end

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

    def <<(kvs)
      kvs.must(Core)
      self[kvs.ext] = kvs
    end

    alias :lookup :[]
    extend self
  end
end

require 'ccp/kvs/hash'
require 'ccp/kvs/tch'
require 'ccp/kvs/kch'

