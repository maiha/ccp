module Ccp
  module Utils
    module Colorize
      # [examples]
      # Ccp::Utils::Colorize::Fore.red("hello")
      # Ccp::Utils::Colorize::Back.red("hello")
      # Ccp::Utils::Colorize.red("hello")        # same as Fore
      # Ccp::Utils::Colorize.strip(ansi_color_string)
      # Ccp::Utils::Colorize::Bar.success("[%s]", 10, 0.5)  # => "[||||    ]"

      module Fore
        CLEAR   = "\e[0m"
        BLACK   = "\e[30m"
        RED     = "\e[31m"
        GREEN   = "\e[32m"
        YELLOW  = "\e[33m"
        BLUE    = "\e[34m"
        MAGENTA = "\e[35m"
        CYAN    = "\e[36m"
        WHITE   = "\e[37m"

        def colorize(text, code); code + text.to_s + CLEAR; end

        def black  (text) BLACK   + text.to_s + CLEAR; end
        def red    (text) RED     + text.to_s + CLEAR; end
        def green  (text) GREEN   + text.to_s + CLEAR; end
        def yellow (text) YELLOW  + text.to_s + CLEAR; end
        def blue   (text) BLUE    + text.to_s + CLEAR; end
        def magenta(text) MAGENTA + text.to_s + CLEAR; end
        def purple (text) MAGENTA + text.to_s + CLEAR; end # alias
        def pink   (text) MAGENTA + text.to_s + CLEAR; end # alias
        def cyan   (text) CYAN    + text.to_s + CLEAR; end
        def aqua   (text) CYAN    + text.to_s + CLEAR; end # alias
        def white  (text) WHITE   + text.to_s + CLEAR; end
        extend self
      end

      module Back
        CLEAR   = "\e[0m"
        BLACK   = "\e[40m"
        RED     = "\e[41m"
        GREEN   = "\e[42m"
        YELLOW  = "\e[43m"
        BLUE    = "\e[44m"
        MAGENTA = "\e[45m"
        CYAN    = "\e[46m"
        WHITE   = "\e[47m"

        def colorize(text, code); code + text.to_s + CLEAR; end

        def black  (text) BLACK   + text.to_s + CLEAR; end
        def red    (text) RED     + text.to_s + CLEAR; end
        def green  (text) GREEN   + text.to_s + CLEAR; end
        def yellow (text) YELLOW  + text.to_s + CLEAR; end
        def blue   (text) BLUE    + text.to_s + CLEAR; end
        def magenta(text) MAGENTA + text.to_s + CLEAR; end
        def purple (text) MAGENTA + text.to_s + CLEAR; end # alias
        def pink   (text) MAGENTA + text.to_s + CLEAR; end # alias
        def cyan   (text) CYAN    + text.to_s + CLEAR; end
        def aqua   (text) CYAN    + text.to_s + CLEAR; end # alias
        def white  (text) WHITE   + text.to_s + CLEAR; end
        extend self
      end

      ######################################################################
      ### Bar

      module Bar
        class Progress
          def initialize(colors, format, size, vals, chars = nil)
            @colors = colors.must.coerced(Array, Symbol=>lambda{|x| [x, :black]}) # [:green, :black]
            @format = format.must(String)               # "Mem[%sMB]"
            @size   = size.must(Integer)                # 73
            @vals   = vals.must(Integer, Float, Array) # [4004,24105]
            @chars  = chars.must(Array)  { ["|"] }
            @count  = @vals.is_a?(Array) ? @vals.size : 1 # value count (fill gaps with Integer and Array)

            if @vals.is_a?(Array) and @vals.size < 2
              raise "vals.size expected >= %d, but got %d" % [2, @vals.size]
            end
            if @chars.size < @count
              @chars += [@chars.last] * (@vals.size - @chars.size)
            end
            if @chars.size < @count + 1
              @chars += [' ']
            end
            @colors.size >= 2 or raise "colors.size expected >= %d, but got %d" % [2, @colors.size]

            @label  = label(@vals)                    # "4004/24105"
            @rates  = rates(@vals)                    # [0.16]
          end

          def to_s
            rest = @size - @format.size + 2 - @label.size
            return @format % @label if rest <= 0
            return @format % (bar(rest) + @label)
          end

          private
            def bar(max)
              o = @chars.first * ((max * @rates).ceil)  # "||||"
              x = @chars.last  * (max - o.size)         # "                  "
              Colorize.__send__(@colors.first, o) + Colorize.__send__(@colors.last, x)
            end

            def label(width)
              p = lambda{|x| x.is_a?(Float) ? ("%.1f" % x) : x.to_s }

              case width
              when Float
                return("%.1f%%" % [width*100])
              when Array
                return width.map{|_| p[_]}.join("/")
              else
                return p[width] + "%"
              end
            end

            def rates(vals)
              return _rate(vals)
            end

            def _rate(x)
              r = case x
                  when Integer ; x / 100.0
                  when Float  ; x
                  when Array  ; (v, a) = x; _rate(v.to_f/a)
                  else ; raise "error: rate got #{x.class}"
                  end
              return [[0.0, r].max, 1.0].min
            end
        end

        def green (*args) Progress.new(:green , *args).to_s; end
        def blue  (*args) Progress.new(:blue  , *args).to_s; end
        def yellow(*args) Progress.new(:yellow, *args).to_s; end
        def red   (*args) Progress.new(:red   , *args).to_s; end

        alias :success :green
        alias :info    :blue
        alias :warning :yellow
        alias :danger  :red

        extend self
      end

      ######################################################################
      ### Meter

      module Meter
        class Percent < Bar::Progress
          private
            def bar(max)
              buf  = ''
              sum = 0
              @rates.each_with_index do |r, i|
                v = @chars[i]  || @chars.first
                c = @colors[i] || @chars.first
                s = (max * r).ceil
                s = max - sum unless sum + s <= max # validate sum should <= max
                o = v * s   # "||||"
                sum += s
                buf << Colorize.__send__(c, o)
              end
              buf << @chars.last * (max - sum)
              return buf
            end

            def rates(vals)
              rs = vals.map{|v| v /= 100.0; [[0.0, v].max, 1.0].min }
              # validate sum should <= 1.0

              sum = 0.0
              rs.each_with_index do |r,i|
                available = 1.0 - sum
                if r > available
                  rs[i] = available
                  (i+1 ... rs.size).each{|_| rs[_] = 0.0}
                  return rs
                end
                sum += r
              end
              return rs
            end

            def label(*)
              ""
            end
        end

        def percent(fmt, size, vals, cols, c = nil) Percent.new(cols, fmt, size, vals, c).to_s; end

        extend self
      end

      def self.strip(string)
        string.gsub(/\x1B\[[0-9;]*[mK]/, '')
      end

      include Fore
      extend  Fore
    end
  end
end
