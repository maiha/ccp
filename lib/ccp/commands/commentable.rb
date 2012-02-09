module Ccp
  module Commands
    module Commentable
      def MEMO(*messages)
        from = caller.is_a?(Array) ? caller.first : self.class
        receiver.comment("MEMO: #{_build_comment(*messages)}\n  #{from}")
      end

      def TODO(*messages)
        from = caller.is_a?(Array) ? caller.first : self.class
        receiver.comment("TODO: #{_build_comment(*messages)}\n  #{from}", :warn)
      end

      private
        def _build_comment(*objs)
          objs = objs.first if objs.size == 1
          objs.is_a?(String) ? objs : objs.inspect
        end
    end
  end
end
