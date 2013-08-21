module Ccp
  module Serializers
    module Core
      def ext         ; self.class.name.split(/::/).last.to_s.downcase; end
      def encode(val) ; raise NotImplementedError, "subclass resposibility"; end
      def decode(val) ; raise NotImplementedError, "subclass resposibility"; end

      def self.included(klass)
        klass.extend klass
        klass.module_eval do
          def self.ext; name.split(/::/).last.to_s.downcase; end
        end
      end
    end
  end
end
