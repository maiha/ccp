# -*- coding: utf-8 -*-

# provide variables shared by commands

module Ccp
  module Receivers
    module Variables
      def data
        @data ||= Typed::Hash.new
      end

      def data?(key)
        data.set?(key)
      end

      def parse!(options)
        data.merge!(options)
      end
    end
  end
end
