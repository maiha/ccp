module Ccp
  module Kvs
    module Core
      def get(k)   ; raise NotImplementedError, "subclass resposibility"; end
      def set(k,v) ; raise NotImplementedError, "subclass resposibility"; end
      def del(k)   ; raise NotImplementedError, "subclass resposibility"; end

      def open(*)  ; end
      def close    ; end
      def source   ; @source; end
      def count    ; end
      def touch    ; end

      def [](k)    ; get(k)   ; end
      def []=(k,v) ; set(k,v) ; end
      def put(k,v) ; set(k,v) ; end
      def out(k)   ; del(k)   ; end

      def ext; self.class.name.split(/::/).last.to_s.downcase; end
      def self.included(klass)
        klass.class_eval do
          def self.ext; name.split(/::/).last.to_s.downcase; end
          def self.open(*args); new.tap{|kvs| kvs.open(*args)}; end
        end
      end
    end
  end
end