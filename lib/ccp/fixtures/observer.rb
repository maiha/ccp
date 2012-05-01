module Ccp
  module Fixtures
    class Observer
      attr_reader :read, :write

      def initialize(data)
        @data  = data.must(Typed::Hash)
        @read  = {}
        @write = {}
      end

      def start
        @data.events.on(:read ) {|k,v| @read[k] ||= v}
        @data.events.on(:write) {|k,v| @write[k] = v}
      end

      def stop
        # remove events (this depends on typed.gem)
        # NotImplementedYet
      end
    end
  end
end
