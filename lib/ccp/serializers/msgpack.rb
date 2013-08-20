require 'msgpack'

module Ccp
  module Serializers
    module Msgpack
      include Core

      def ext        ; "msgpack"              ; end
      def encode(obj); MessagePack.pack(obj)  ; end
      def decode(obj); MessagePack.unpack(obj); end

      extend self
    end
  end
end
