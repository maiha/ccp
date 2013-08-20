require 'ccp/serializers/core'
require 'ccp/serializers/json'
require 'ccp/serializers/yaml'
require 'ccp/serializers/msgpack'

module Ccp
  module Serializers
    NotFound = Class.new(RuntimeError)
    
    DICTIONARY = {}             # cache for (extname -> Serializer)

    def self.reload!
      DICTIONARY.clear
    end
    
    def self.dictionary
      if DICTIONARY.blank?
        constants.each do |name|
          v = const_get(name)
          next unless v.is_a?(Core)
          k = (begin; v.ext; rescue => e; e; end).to_s
          DICTIONARY[k] = v
        end
      end
      return DICTIONARY
    end

    def self.lookup(name)
      return dictionary[name.to_s] || name.must(Core) { raise NotFound, "%s(%s) for %s" % [name, name.class, dictionary.inspect] }
    end
  end
end
