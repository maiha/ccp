module Ccp
  module Commands
    module Executable

      ### Command

      def execute
      end

      ### Profiling

      def benchmark(method = :execute)
        receiver.profile(self, method)
      end
    end
  end
end
