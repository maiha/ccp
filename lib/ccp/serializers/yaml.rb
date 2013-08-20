require 'yaml'

module Ccp
  module Serializers
    module Yaml
      include Core

      def ext         ; "yaml"         ; end
      def encode(val) ; val.to_yaml    ; end
      def decode(val) ; YAML.load(val) ; end

      extend self
    end
  end
end
