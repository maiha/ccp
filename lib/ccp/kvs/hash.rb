module Ccp
  module Kvs
    class Hash
      include Core

      delegate :keys, :to=>"@db"

      def initialize
        @db = {}
      end

      def get(k)   ; decode(@db[k.to_s])         ; end
      def set(k,v) ; @db[k.to_s] = encode(v).to_s; end
      def set!(k,v); set(k,v)                    ; end
      def del(k)   ; decode(@db.delete(k.to_s))  ; end
      def count    ; @db.size                    ; end
      def clear    ; @db.clear                   ; end
    end
  end
end

Ccp::Kvs << Ccp::Kvs::Hash
