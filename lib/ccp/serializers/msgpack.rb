require 'msgpack'

module Ccp
  module Serializers
    module Msgpack
      include Core

      def encode(obj); MessagePack.pack(obj)  ; end
      def decode(obj); MessagePack.unpack(obj); end
    end
  end
end
