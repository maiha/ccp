module Ccp
  module Receivers
    module Loggable
      def logger
        @logger ||= data?(:logger) ? data[:logger] : (data[:logger] = build_logger)
      end

      private
        def build_logger
          Logger.new(STDOUT)
        end
    end
  end
end
