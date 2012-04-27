module Ccp
  module Commands
    module Core
      include Receivable
      include Commentable
      include Executable

      def self.included(base)
        base.class_eval do
          extend ClassMethods
        end
      end

      def inspect
        klass_name = self.class.name.to_s.split(/::/).last
        "#<#{klass_name}>"
      end
    end
  end
end
