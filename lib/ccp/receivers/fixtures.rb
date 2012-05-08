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
        if fixture_save?(cmd)
          fixture_stub(cmd)
          observer = Ccp::Fixtures::Observer.new(data)
          observer.start
          super
          observer.stop
          fixture_mock(cmd)
          fixture_save(cmd, observer.read, observer.write)
        else
          fixture_stub(cmd)
          super
          fixture_mock(cmd)
        end
      end

      def setup
        super

        # Schema
        self[:fixture_save]     = Object # Define schema explicitly to accept true|false|Proc
        self[:fixture_keys]     = Object # Define schema explicitly to accept true|[String]

        # Values
        self[:fixture_dir]      = "tmp/fixtures"
        self[:fixture_kvs]      = :file
        self[:fixture_ext]      = :json
        self[:fixture_save]     = false
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

      def fixture_stub(cmd)
        return unless cmd.class.stub

#        kvs = Ccp::Persistent.load(path)
        
      end

      def fixture_mock(cmd)
        return unless cmd.class.mock
      end

      def fixture_save?(cmd)
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
        path      = self[:fixture_path_for].call(cmd)
        versioned = Ccp::Persistent::Versioned.new(path, :kvs=>self[:fixture_kvs], :ext=>self[:fixture_ext])
        versioned["stub"].save(stub, fixture_keys_filter(stub.keys))
        versioned["mock"].save(mock, fixture_keys_filter(mock.keys))
      end

      def fixture_keys_filter(keys)
        case (obj = self[:fixture_keys])
        when true ; keys
        when false; []
        when Array
          ary = obj.map(&:to_s)
          return keys if ary == []
          if ary.size == ary.grep(/^!/).size
            return keys.dup.reject{|v| ary.include?("!#{v}")}
          else
            ary & keys
          end
        else
          raise ":fixture_keys is invalid: #{obj.class}"
        end
      end

      def fixture_for(cmd, key)
        kvs  = Ccp::Persistent.lookup(self[:fixture_kvs])
        code = Ccp::Serializers.lookup(self[:fixture_ext])
        path = instance_exec(cmd, &self[:fixture_path_for]) + "#{key}.#{code.ext}.#{kvs.ext}"
        return Storage.new(kvs.new(path, code))
      end

      def default_fixture_path_for
        proc{|cmd| settings.path(:fixture_dir) + cmd.class.name.underscore}
      end
    end
  end
end
