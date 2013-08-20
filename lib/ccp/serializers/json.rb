module Ccp::Serializers::Json
  include Ccp::Serializers::Core

  begin
    require 'yajl'
    Engine = Yajl
  rescue LoadError
    require 'json'
    Engine = JSON
  end

  def self.ext
    "json"
  end

  def self.encode(val)
    Engine.dump(val)
  end

  def self.decode(val)
    Engine.load(val)
  end
end
