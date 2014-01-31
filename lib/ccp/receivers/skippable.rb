module Ccp
  module Receivers
    module Skippable
      def execute(cmd)
        if skip?(cmd)
          notify_skip(cmd)
          return false
        end
        super
      end

      private
        def skip?(cmd)
          key = "skip_%s" % cmd.class.name.underscore.gsub("/","_")
          data.set?(key)
        end

        def notify_skip(cmd)
          logger.debug Utils::Colorize.pink("[SKIP] #{cmd.class}")
        end
    end
  end
end
