module Ccp
  module Kvs
    class Hash
      include Core

      def initialize
        @db = {}
      end

      def get(k)   ; @db[k.to_s]          ; end
      def set(k,v) ; @db[k.to_s] = v.to_s ; end
      def del(k)   ; @db.delete(k.to_s)   ; end
      def count    ; @db.size             ; end
    end
  end
end
