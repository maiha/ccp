module Ccp
  module Receivers
    class Global < Base
      def self.new
        @instance ||= super
      end
    end
  end
end
