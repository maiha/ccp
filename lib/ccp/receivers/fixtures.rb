module Ccp
  module Receivers
    module Fixtures
      class Storage
        def initialize(kvs)
          @kvs = kvs
        end

        def save(data)
          data.keys.each do |key|
            @kvs[key.to_s] = data[key]
          end
        end

        def load
          raise NotImplementedError
        end
      end

      def execute(cmd)
        return super unless fixtures_save?(cmd)

        observer = Ccp::Fixtures::Observer.new(data)
        observer.start
        super
        observer.stop

        fixtures_save(cmd, observer.read, observer.write)
      end

      def setup
        super

        self[:fixture_save]     = Object # Schema

        self[:fixture_dir]      = "tmp/fixtures"
        self[:fixture_kvs]      = :file
        self[:fixture_ext]      = :json
        self[:fixture_save]     = proc{|cmd| false }
        self[:fixture_path_for] = proc{|cmd| settings.path(:fixture_dir) + cmd.class.name.underscore}
      end

      def parse!(options)
        settings.keys.each do |key|
          if key.to_s =~ /^fixture_/ and options.has_key?(key)
            self[key] = options.delete(key)
          end
        end
        super
      end

      def fixtures_save?(cmd)
        case (obj = self[:fixture_save])
        when true ; obj
        when false; obj
        when Proc; obj.call(cmd)
        else; raise ":fixture_save is invalid: #{obj.class}"
        end
      end

      def fixtures_save(cmd, read, write)
        path      = self[:fixture_path_for].call(cmd)
        versioned = Ccp::Persistent::Versioned.new(path, :kvs=>self[:fixture_kvs], :ext=>self[:fixture_ext])
        versioned["read" ].save(read)
        versioned["write"].save(write)
      end

      def fixtures_for(cmd, key)
        kvs  = Ccp::Persistent.lookup(self[:fixture_kvs])
        code = Ccp::Serializers.lookup(self[:fixture_ext])
        path = self[:fixture_path_for].call(cmd) + "#{key}.#{code.ext}.#{kvs.ext}"
        return Storage.new(kvs.new(path, code))
      end
    end
  end
end
