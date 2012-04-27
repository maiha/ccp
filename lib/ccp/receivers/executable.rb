module Ccp
  module Receivers
    module Executable
      def execute(cmd)
        cmd.must.duck!("before") {}
        profile(cmd) { cmd.execute }
        cmd.must.duck!("after") {}
      end
    end
  end
end
