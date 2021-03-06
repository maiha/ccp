# -*- coding: utf-8 -*-

# provide variables used in receiver itself

module Ccp
  module Receivers
    module Settings
      def settings
        @settings ||= Typed::Hash.new
      end

      def [](key)
        settings[key]
      end

      def []=(key, val)
        settings[key] = val
      end
    end
  end
end
