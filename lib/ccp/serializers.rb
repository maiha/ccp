require 'ccp/serializers/core'

module Ccp
  module Serializers
    NotFound = Class.new(RuntimeError)
    
    DICTIONARY = {}             # cache for (extname -> Serializer)

    include Enumerable
    delegate :delete, :to=>"DICTIONARY"

    def each(&block)
      DICTIONARY.each_value(&block)
    end

    def [](name)
      return name.must.coerced(Core, Symbol => :to_s, String => proc{|key| DICTIONARY[key]}) {
        raise NotFound, "%s(%s) for %s" % [name, name.class, DICTIONARY.keys.inspect]
      }
    end

    def []=(key, val)
      DICTIONARY[key.to_s] = val.must(Core)
    end

    alias :lookup :[]
    extend self
  end
end

require 'ccp/serializers/json'
require 'ccp/serializers/yaml'
require 'ccp/serializers/msgpack'

Ccp::Serializers[:json]    = Ccp::Serializers::Json
Ccp::Serializers[:yaml]    = Ccp::Serializers::Yaml
Ccp::Serializers[:msgpack] = Ccp::Serializers::Msgpack

