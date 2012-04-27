module Ccp
  module Receivers
    module Profileable
      include Colorize

      Profile = Struct.new(:target, :method, :time)
      class Profile
        def name
          target.is_a?(Class) ? "#{target.name}.#{method}" : "#{target.class}##{method}"
        end

        def profile(total)
          "[%4.1f%%] %.7f %s" % [(time*100/total), time, name]
        end
      end

      def profile(target, &block)
        start = Time.new
        block.call

        case target
        when Ccp::Commands::Composite
          # no profiles
        else
          profiles << Profile.new(target, "execute", (Time.new - start).to_f)
        end
      end

      def profiles
        @profiles ||= []
      end

      def show_profiles(*args, &block)
        opts   = Optionize.new(args, :benchs, :output)
        benchs = opts[:benchs] || profiles
        output = opts[:output] || $stderr

        # search worst item
        total = 0
        worst = nil
        benchs.each do |bench|
          total += bench.time
          worst = bench if !worst or bench.time > worst.time
        end

        benchs.each do |bench|
          colorize = (bench == worst) ? :pink : :aqua
          profiled = __send__(colorize, bench.profile(total))
          if block
            block.call(profiled)
          else
            output.puts profiled
          end
        end
      end

    end
  end
end
