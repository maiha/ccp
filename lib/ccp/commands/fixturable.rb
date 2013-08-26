module Ccp
  module Commands
    module Fixturable
      def self.included(base)
        base.class_eval do
          include Ccp::Utils::Options
          dsl_accessor :fixture, options(:stub, :mock, :fail, :save, :keys, :dir, :kvs, :ext)

          def self.test(options = {})
            execute({:fixture_test=>true,:logger=>Logger.new(STDOUT)}.merge(options))
          end
        end
      end
    end
  end
end
