module Ccp
  module Receivers
    module Core
      def setup
      end

      def inspect
        klass_name = self.class.name.to_s.split(/::/).last

        "#<Receivers::#{klass_name} data:#{data.inspect}>"
      end
    end
  end
end
