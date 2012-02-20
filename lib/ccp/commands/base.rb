module Ccp
  module Commands
    class Base
      include Ccp::Commands::Core

      attr_reader :args

      def initialize(*args)
        @args = args
      end
    end
  end
end
