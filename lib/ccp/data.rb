# -*- coding: utf-8 -*-

require 'pathname'

module Ccp
  module Data
    module Ext
      def path(key)
        self[key].must.coerced(Pathname, String=>proc{|i| Pathname(i)})
      end

      def merge(options)
        options.each_pair do |key,val|
          self[key] = val
        end
      end

      def merge_default(options)
        options.each_pair do |key,val|
          default[key] = val
        end
      end
    end

    def data
      @data ||= Typed::Hash.new.extend Ext
    end

    def data?(key)
      data.set?(key)
    end

    def parse!(options)
      data.merge(options)
    end
  end
end
