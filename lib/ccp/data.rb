# -*- coding: utf-8 -*-

require 'pathname'

module Ccp
  module Data
    module Pathable
      def path(key)
        self[key].must.coerced(Pathname, String=>proc{|i| Pathname(i)})
      end
    end

    def data
      @data ||= Typed::Hash.new.extend Pathable
    end

    def data?(key)
      data.set?(key)
    end
  end
end
