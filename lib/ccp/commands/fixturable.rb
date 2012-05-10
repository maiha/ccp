module Ccp
  module Commands
    module Fixturable
      def self.included(base)
        base.class_eval do
          include Ccp::Utils::Options
          dsl_accessor :fixture, options(:stub, :mock, :fail)
        end
      end
    end
  end
end
