module Ccp
  module Kvs
    class Hash
      include Core

      def initialize
        @db = {}
      end

      def get(k)   ; @db[k]        ; end
      def set(k,v) ; @db[k] = v    ; end
      def del(k)   ; @db.delete(k) ; end
    end
  end
end
