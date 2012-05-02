module Ccp::Serializers::Json
  include Ccp::Serializers::Core

  def self.ext
    "json"
  end

  def self.encode(val)
    JSON.dump(val)
  end

  def self.decode(val)
    JSON.load(val)
  end
end
