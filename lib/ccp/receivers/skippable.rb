module Ccp
  module Receivers
    module Skippable
      def execute(cmd)
        return false if skip?(cmd)
        super
      end

      private
        def skip?(cmd)
          key = "skip_%s" % cmd.class.name.underscore.gsub("/","_")
          data.set?(key)
        end
    end
  end
end
