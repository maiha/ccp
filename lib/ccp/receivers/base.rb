module Ccp
  module Receivers
    class Base
      include Ccp::Data
      include Profileable
      include Commentable

      def inspect
        klass_name = self.class.name.to_s.split(/::/).last

        "#<Receivers::#{klass_name} data:#{data.inspect}>"
      end
    end
  end
end
