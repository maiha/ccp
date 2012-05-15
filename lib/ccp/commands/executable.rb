module Ccp
  module Commands
    module Executable
      def self.included(base)
        base.class_eval do
          def self.execute(options = {})
            c = new
            c.receiver = options.delete(:receiver)
            c.receiver.parse!(options)
            c.receiver.execute(c)
            return c
          end
        end
      end

      ### Command

      def execute
      end
    end
  end
end
