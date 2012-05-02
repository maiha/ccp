module Ccp
  module Receivers
    module Fixtures
      def execute(cmd)
        if save_fixture?(cmd)
          observer = Ccp::Fixtures::Observer.new(data)
          observer.start
          super
          observer.stop

          fixtures
          save_fixture_storage_for(cmd, "in")
          versioned = 

          path = save_fixture_path_for(cmd)
          Ccp::Fixtures::Writers::YamlWriter[path + "in.yaml" ] = observer.read
          Ccp::Fixtures::Writers::YamlWriter[path + "out.yaml"] = observer.write
        else
          super
        end
      end

      def setup
        super
        self[:save_fixture]          = false
        self[:save_fixture_dir]      = "tmp/fixtures"
        self[:save_fixture_kvs]      = :dir
        self[:save_fixture_ext]      = :json
        self[:save_fixture_path_for] = proc{|cmd| settings.path(:save_fixture_dir) + cmd.class.name.underscore}
        self[:save_fixture_p]        = proc{|cmd| self[:save_fixture]}
      end

      def parse!(options)
        dir = options.delete(:save_fixture_dir)
        self[:save_fixture_dir] = dir.to_s if dir
        super
      end

      def save_fixture?(cmd)
        self[:save_fixture_p].call(cmd)
      end

      def save_fixture_storage_for(cmd, key)
        kvs  = Ccp::Persistent.lookup(self[:save_fixture_kvs])
        code = Ccp::Serializers.lookup(self[:save_fixture_ext])
        path = self[:save_fixture_path_for].call(cmd) + "#{key}.#{code.ext}.#{kvs.ext}"
        return kvs.new(path, code)
      end
    end
  end
end
