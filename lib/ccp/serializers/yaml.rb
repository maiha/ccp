module Ccp::Serializers::Yaml
  include Ccp::Serializers::Core

  def self.ext
    "yaml"
  end

  def self.encode(val)
    val.to_yaml
  end

  def self.decode(val)
    YAML.load(val)
  end
end
