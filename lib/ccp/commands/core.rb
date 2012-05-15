module Ccp
  module Commands
    module Core
      def self.included(base)
        super
        base.class_eval do
          include Receivable
          include Commentable
          include Executable
          include Fixturable
        end
      end

      def inspect
        klass_name = self.class.name.to_s.split(/::/).last
        "#<#{klass_name}>"
      end
    end
  end
end
