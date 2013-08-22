require 'tokyocabinet'

module Ccp
  module Kvs
    class Tch
      include Core

      def get(k)   ; raise NotImplementedError, "subclass resposibility"; end
      def set(k,v) ; raise NotImplementedError, "subclass resposibility"; end
      def del(k)   ; raise NotImplementedError, "subclass resposibility"; end

      def open(*)  ; end;
      def close    ; end;
    end
  end
end
