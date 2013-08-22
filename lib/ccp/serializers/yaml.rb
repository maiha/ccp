require 'yaml'

module Ccp
  module Serializers
    module Yaml
      include Core

      def encode(val) ; val.to_yaml    ; end
      def decode(val) ; YAML.load(val) ; end
    end
  end
end
