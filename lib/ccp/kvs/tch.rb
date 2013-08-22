require 'tokyocabinet'

module Ccp
  module Kvs
    class Tch < Tokyo::Cabinet
      def get(k)   ; R{ super }; end
      def set(k,v) ; W{ super }; end
      def del(k)   ; W{ super }; end
      def count    ; R{ super }; end
      def keys     ; R{ super }; end
    end
  end
end
