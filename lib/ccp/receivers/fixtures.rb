module Ccp
  module Receivers
    module Fixtures
      def execute(cmd)
        if fixture_save?(cmd)
          observer = Ccp::Fixtures::Observer.new(data)
          observer.start
          super
          observer.stop
          fixture_save(cmd, observer.read, observer.write)

        elsif fixture_test?(cmd)
          stub = fixture_versioned_for(cmd)["stub"].path
          fixture_stub(cmd.class.stub || (stub.exist? ? stub : nil))
          super
          mock = fixture_versioned_for(cmd)["mock"].path
          fixture_mock(cmd, cmd.class.mock || mock)

        else
          fixture_stub(cmd.class.stub)
          super
          fixture_mock(cmd, cmd.class.mock)
        end
      end

      def setup
        super

        # Schema
        self[:fixture_save]     = Object # Define schema explicitly to accept true|false|Proc
        self[:fixture_test]     = Object # Define schema explicitly to accept true|false|Proc
        self[:fixture_keys]     = Object # Define schema explicitly to accept true|[String]

        # Values
        self[:fixture_dir]      = "tmp/fixtures"
        self[:fixture_kvs]      = :file
        self[:fixture_ext]      = :json
        self[:fixture_save]     = false
        self[:fixture_test]     = false
        self[:fixture_keys]     = true
        self[:fixture_path_for] = default_fixture_path_for
      end

      def parse!(options)
        settings.keys.grep(/^fixture_/).each do |key|
          self[key] = options.delete(key.to_sym) if options.has_key?(key.to_sym)
          self[key] = options.delete(key) if options.has_key?(key)
        end
        super
      end

      def fixture_stub(path)
        return unless path
        hash = Ccp::Persistent.load(path).read!
        data.merge!(hash)
      rescue Ccp::Persistent::NotFound => e
        raise Ccp::Fixtures::NotFound, e.to_s
      end

      def fixture_mock(cmd, path)
        return unless path
        hash = Ccp::Persistent.load(path).read!

        hash.keys.each do |key|
          fixture_validate(cmd, key, data, hash)
        end
      rescue Ccp::Persistent::NotFound => e
        raise Ccp::Fixtures::NotFound, e.to_s
      end

      def fixture_validate(cmd, key, data, hash)
        data.exist?(key)       or fixture_fail(cmd, key)
        data[key] == hash[key] or fixture_fail(cmd, key, hash[key], data[key])
        # or, success
      end

      def fixture_fail(cmd, key, expected = nil, got = nil)
        block = fixture_fail_for(cmd)
        instance_exec(cmd, key, expected, got, &block)
      end

      def fixture_fail_for(cmd)
        cmd.class.fail || method(:default_fixture_fail)
      end

      def default_fixture_fail(cmd, key, exp, got)
        Ccp::Utils::TestFailed::PROC.call(cmd, key, exp, got)
      end

      def fixture_save?(cmd)
        # highest priority
        case cmd.class.save
        when true  ; return true
        when false ; return false
        end

        case (obj = self[:fixture_save])
        when true  ; true
        when false ; false
        when String; cmd.class.name == obj
        when Array ; ary = obj.map(&:to_s); name = cmd.class.name
          return false if ary.blank?
          return true  if ary.include?(name)
          return false if ary.include?("!#{name}")
          return true  if ary.size == ary.grep(/^!/).size
          return false
        when Proc  ; instance_exec(cmd, &obj).must(true,false) {raise ":fixture_save should return true|false"}
        else; raise ":fixture_save is invalid: #{obj.class}"
        end
      end

      def fixture_save(cmd, stub, mock)
        versioned = fixture_versioned_for(cmd)
        keys = cmd.class.keys || self[:fixture_keys]
        kvs  = Ccp::Persistent.lookup(versioned.kvs)

        # stub
        storage = cmd.class.stub ? kvs.new(cmd.class.stub, versioned.ext) : versioned["stub"]
        storage.save(stub, fixture_keys_filter(keys, stub.keys))

        # mock
        storage = cmd.class.mock ? kvs.new(cmd.class.mock, versioned.ext) : versioned["mock"]
        storage.save(mock, fixture_keys_filter(keys, mock.keys))
      end

      def fixture_test?(cmd)
        case (obj = self[:fixture_test])
        when true  ; true
        when false ; false
        when String; cmd.class.name == obj
        when Array ; ary = obj.map(&:to_s); name = cmd.class.name
          return false if ary.blank?
          return true  if ary.include?(name)
          return false if ary.include?("!#{name}")
          return true  if ary.size == ary.grep(/^!/).size
          return false
        when Proc  ; instance_exec(cmd, &obj).must(true,false) {raise ":fixture_test should return true|false"}
        else; raise ":fixture_test is invalid: #{obj.class}"
        end
      end

      def fixture_keys_filter(acl, keys)
        case acl
        when true ; keys
        when false; []
        when Array
          ary = acl.map(&:to_s)
          return keys if ary == []
          if ary.size == ary.grep(/^!/).size
            return keys.dup.reject{|v| ary.include?("!#{v}")}
          else
            ary & keys
          end
        else
          raise ":fixture_keys is invalid: #{acl.class}"
        end
      end

      def default_fixture_path_for
        proc{|cmd| settings.path(:fixture_dir) + cmd.class.name.underscore}
      end

      private
        def runtime_stubs
          @runtime_stubs ||= {} # key:cmd object, val:filename
        end

        def runtime_mocks
          @runtime_mocks ||= {} # key:cmd object, val:filename
        end

        def fixture_versioned_for(cmd)
          dir  = cmd.class.dir
          path = dir ? (Pathname(dir) + cmd.class.name.underscore) : self[:fixture_path_for].call(cmd)

          kvs  = cmd.class.kvs || self[:fixture_kvs]
          ext  = cmd.class.ext || self[:fixture_ext]

          versioned = Ccp::Persistent::Versioned.new(path, :kvs=>kvs, :ext=>ext)
          return versioned
        end
    end
  end
end
