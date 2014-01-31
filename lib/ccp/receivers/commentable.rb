module Ccp
  module Receivers
    module Commentable

      Comment = Struct.new(:text, :level)
      class Comment
        include Utils::Colorize
        def colorized
          case level
          when :warn          ; yellow(text)
          when :error, :fatal ; red(text)
          when :info          ; green(text)
          else                ; text
          end
        end
      end

      def comment(text, level = nil)
        comments[text] ||= Comment.new(text, level)
      end

      def comments
        @comments ||= ActiveSupport::OrderedHash.new
      end

      def show_comments(*args)
        comments.each_value do |comment|
          logger.info comment.colorized
        end
      end
    end
  end
end
