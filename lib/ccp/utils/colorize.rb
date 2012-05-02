module Ccp
  module Utils
    module Colorize
      def colorize(text, ansi); "#{ansi}#{text}\e[0m"; end
      def red   (text); colorize(text, "\e[31m"); end
      def green (text); colorize(text, "\e[32m"); end
      def yellow(text); colorize(text, "\e[33m"); end
      def blue  (text); colorize(text, "\e[34m"); end
      def pink  (text); colorize(text, "\e[35m"); end
      def aqua  (text); colorize(text, "\e[36m"); end

      extend self
    end
  end
end
