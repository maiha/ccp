module Ccp
  module Receivers
    module SaveFixture
      attr_accessor :save_fixture_dir

      def execute(cmd)
        if save_fixture?(cmd)
          observer = Ccp::Fixtures::Observer.new(data)
          observer.start
          super
          observer.stop
          path = save_fixture_path_for(cmd)
          Ccp::Fixtures::Writers::YamlWriter[path + "in.yaml" ] = observer.read
          Ccp::Fixtures::Writers::YamlWriter[path + "out.yaml"] = observer.write
        else
          super
        end
      end

      def parse!(options)
        dir = options.delete(:save_fixture_dir)
        @save_fixture_dir = dir if dir

        super
      end

      def save_fixture?(cmd)
        if data?(:save_fixture)
          return true
        else
          # indivisual fixture is not supported yet
          return false
        end
      end

      def save_fixture_path_for(cmd)
        Pathname(save_fixture_dir || save_fixture_default_dir) + cmd.class.name.underscore
      end

      def save_fixture_default_dir
        "tmp/fixtures"
      end
    end
  end
end
