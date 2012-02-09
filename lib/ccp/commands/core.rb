module Ccp
  module Commands
    module Core
      include Receivable
      include Executable
      include Commentable

      def inspect
        klass_name = self.class.name.to_s.split(/::/).last
        "#<#{klass_name}>"
      end
    end
  end
end
