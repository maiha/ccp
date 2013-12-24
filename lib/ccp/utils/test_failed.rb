module Ccp
  module Utils
    module TestFailed
      Differ = Struct.new(:a, :b, :path)
      class Differ
        def execute
          unless a.class == b.class
            failed("%s expected [%s], but got [%s]" % [path, a.class, b.class])
          end

          if a.class == Array
            max = [a.size, b.size].max
            (0...max).each do |i|
              Differ.new(a[i], b[i], "#{path}[#{i}]").execute
            end
            return true
          end

          if a.class == Hash
            (a.keys | b.keys).each do |key|
              Differ.new(a[key], b[key], "#{path}[#{key}]").execute
            end
            return true
          end

          unless a == b
            failed("%s expected %s, but got %s" % [path, a.inspect, b.inspect])
          end
        end

        private
          def failed(msg)
            raise Ccp::Failed, msg
          end
      end

      PROC = proc {|cmd, key, exp, got|
        if exp == nil and got == nil
          raise Ccp::Failed, "#{cmd.class} should write #{key} but not found"
        end
        TestFailed::Differ.new(exp, got, key).execute
        raise Ccp::Failed, "[FATAL] %s expected %s, but got %s" % [cmd.class, exp.class, got.class]
      }
    end
  end
end
