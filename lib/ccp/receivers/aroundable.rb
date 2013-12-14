module Ccp
  module Receivers
    module Aroundable
      def execute(cmd)
        cmd.must.duck!("before") {}
        super
      ensure
        cmd.must.duck!("after") {}
      end
    end
  end
end
