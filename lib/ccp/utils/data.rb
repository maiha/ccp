# -*- coding: utf-8 -*-

require 'pathname'

module Ccp
  module Utils
    class Data < Typed::Hash
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
  end
end
