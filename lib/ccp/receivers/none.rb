module Ccp
  module Receivers
    class None < Base
      def self.new
        @instance ||= super
      end
    end
  end
end
