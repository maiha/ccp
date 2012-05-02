module Ccp::Serializers
  NotFound = Class.new(RuntimeError)

  autoload :Core , 'ccp/serializers/core'
  autoload :Json , 'ccp/serializers/json'
  autoload :Yaml , 'ccp/serializers/yaml'

  def self.lookup(name)
    case name
    when :json, 'json'; Ccp::Serializers::Json
    when :yaml, 'yaml'; Ccp::Serializers::Yaml
    else
      Ccp::Serializers::Core.instance_methods.each do |key|
        name.must.duck(key) { raise NotFound, "%s: %s" % [name.class, name] }
      end
      return name
    end
  end
end
