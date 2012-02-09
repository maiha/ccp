# -*- coding: utf-8 -*-

require 'pathname'

module Ccp
  module Data
    NotDefined = Class.new(RuntimeError)

    class KVS
      delegate :[]=, :to=>"@hash"

      LazyValue = Struct.new(:block)

      class Default
        def initialize(kvs)
          @kvs = kvs
        end

        def []=(key, val)
          return if @kvs.exist?(key)
          @kvs[key] = val
        end

        def regsiter_lazy(key, block)
          return if @kvs.exist?(key)
          raise ArgumentError, "Lazy default value needs block: #{key}" unless block
          @kvs[key] = LazyValue.new(block)
        end
      end

      def initialize
        @hash    = {}
        @default = Default.new(self)
      end

      ######################################################################
      ### Default values

      def default(key = nil, &block)
        if key
          @default.regsiter_lazy(key, block)
        else
          @default
        end
      end

      ######################################################################
      ### Accessor

      def [](key)
        if exist?(key)
          return load(key)
        else
          from = caller.is_a?(Array) ? caller.first : self.class
          raise NotDefined, "'#{key}' is not initialized\n#{from}"
        end
      end

      ######################################################################
      ### Testing

      def exist?(key)
        @hash.has_key?(key)
      end

      def set?(key)
        !! (exist?(key) && self[key])
      end

      def check(key, type)
        self[key].must.struct(type) {
          summary = self[key].inspect
          summary = summary[0,200] + "..." if summary.size > 200
          raise TypeError, "'#{key}' expects '#{type.inspect}', but got #{summary}"
        }
      end

      ######################################################################
      ### Utils

      def path(key)
        self[key].must.coerced(Pathname, String=>proc{|i| Pathname(i)})
      end

      def inspect
        keys = @hash.keys.map(&:to_s).sort.join(',')
        "{#{keys}}"
      end

      private
        def load(key)
          # LazyValue should be evaluated at runtime
          value = @hash[key]
          value = value.block.call if value.is_a?(LazyValue)
          return value
        end
    end

    def data
      @data ||= KVS.new
    end

    def data?(key)
      data.set?(key)
    end
  end
end
