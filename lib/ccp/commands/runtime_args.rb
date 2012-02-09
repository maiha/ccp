# -*- coding: utf-8 -*-
# map options to data

module Ccp
  module Commands
    class RuntimeArgs
      include Core

      def initialize(options = {})
        @options = (options || {}).must(Hash)
      end

      def execute
        @options.each_pair do |key, val|
          data[key] = val
        end
      end

      def inspect
        super.sub(/>$/, " #{@options.inspect}>")
      end
    end
  end
end
