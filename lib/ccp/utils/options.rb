module Ccp
  module Utils
    module Options
      def self.included(base)
        super

        class << base
          def options(*keys)
            Proxy.new(self, *keys)
          end
        end
      end

      class Proxy
        include Enumerable

        attr_reader :keys

        def initialize(base, *keys)
          @base = base
          @keys = keys.map(&:to_sym)

          @keys.each do |key|
            @base.dsl_accessor key
#            instance_eval "def self.#{key}; :#{key}; end"
          end
        end

        def [](key)
          @base.__send__(key)
        end

        def each(&block)
          keys.each do |key|
            yield(self[key])
          end
        end

        def options
          opts = {}
          keys.each do |key|
            val = self[key]
            opts[key] = val unless val.nil?
          end
          return opts
        end
      end
    end
  end
end
