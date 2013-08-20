module Ccp
  module Serializers
    module Core
      def ext         ; raise NotImplementedError, "subclass resposibility"; end
      def encode(val) ; raise NotImplementedError, "subclass resposibility"; end
      def decode(val) ; raise NotImplementedError, "subclass resposibility"; end
    end
  end
end
