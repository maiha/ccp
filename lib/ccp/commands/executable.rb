module Ccp
  module Commands
    module Executable

      ### Command

      def execute
      end

      ### Profiling

      def benchmark
        receiver.profile(self, :execute)
      end
    end
  end
end
