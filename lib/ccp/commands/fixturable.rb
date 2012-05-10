module Ccp
  module Commands
    module Fixturable
      def self.included(base)
        base.dsl_accessor :stub
        base.dsl_accessor :mock
        base.dsl_accessor :fail
      end
    end
  end
end
