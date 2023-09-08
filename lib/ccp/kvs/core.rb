module Ccp
  module Kvs
    module Core
      def get(k)   ; raise NotImplementedError, "subclass resposibility"; end
      def set(k,v) ; raise NotImplementedError, "subclass resposibility"; end
      def set!(k,v); raise NotImplementedError, "subclass resposibility"; end
      def del(k)   ; raise NotImplementedError, "subclass resposibility"; end
      def keys     ; raise NotImplementedError, "subclass resposibility"; end
      def exist?(k); !! get(k)                                          ; end
      def key?(k)  ; exist?(k)                                          ; end

      def open(*)  ; end
      def close    ; end
      def source   ; @source; end
      def count    ; end
      def touch    ; end

      def [](k)    ; get(k)   ; end
      def []=(k,v) ; set(k,v) ; end
      def put(k,v) ; set(k,v) ; end
      def out(k)   ; del(k)   ; end

      def codec    ; @codec                               ; end
      def codec!(c); @codec = Ccp::Serializers[c] ; self  ; end
      def encode(v); @codec ? @codec.encode(v)        : v ; end
      def decode(v); (v && @codec) ? @codec.decode(v) : v ; end

      def ext; self.class.name.split(/::/).last.to_s.downcase; end
      def self.included(klass)
        klass.class_eval do
          def self.ext; name.split(/::/).last.to_s.downcase; end
          def self.open(*args); new.tap{|kvs| kvs.open(*args)}; end
        end
      end

      # bulk operation
      def read     ; keys.inject({}){|h,k| h[k] = get(k); h }           ; end
      def write(h) ; h.each_pair{|k,v| set(k,v)}                        ; end
      def clear    ; keys.each{|k| del(k)}                              ; end
    end
  end
end
