module Ccp
  module Serializers
    module Json
      include Core

      # use Yajl if possible
      begin
        require 'yajl'
        Engine = Yajl
      rescue LoadError
        require 'json'
        Engine = JSON
      end

      def ext         ; "json"           ; end
      def encode(val) ; Engine.dump(val) ; end
      def decode(val) ; Engine.load(val) ; end

      extend self
    end
  end
end
