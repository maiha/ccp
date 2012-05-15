module Ccp
  module Commands
    module Fixturable
      def self.included(base)
        base.class_eval do
          include Ccp::Utils::Options
          dsl_accessor :fixture, options(:stub, :mock, :fail, :save, :keys, :dir, :kvs, :ext)

          extend Testable
        end
      end

      module Testable
        def test(options = {})
          c = new
          c.receiver = options.delete(:receiver)
          c.receiver.parse!(options)
          c.receiver.test(c)
          return c
        end
      end
    end
  end
end
