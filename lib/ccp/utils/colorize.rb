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

      module Bar
        class Progress
          def initialize(colors, format, size, widths, chars = nil)
            @colors = colors.must.coerced(Array, Symbol=>lambda{|x| [x, :black]}) # [:green, :black]
            @format = format.must(String)               # "Mem[%sMB]"
            @size   = size.must(Fixnum)                 # 73
            @widths = widths.must(Fixnum, Float, Array) # [4004,24105]
            @chars  = chars.must(Array)  { ["|", " "] }

            if @widths.is_a?(Array) and @widths.size != 2
              raise "widths.size expected %d, but got %d" % [2, @widths.size]
            end
            @chars.size  == 2 or raise "chars.size expected %d, but got %d" % [2, @chars.size]
            @colors.size == 2 or raise "colors.size expected %d, but got %d" % [2, @colors.size]

            @label  = label(@widths)                    # "4004/24105"
            @rate   = rate(@widths)                     # 0.16
          end

          def to_s
            rest = @size - @format.size + 2 - @label.size
            return @format % @label if rest <= 0
            return @format % (bar(rest) + @label)
          end

          private
            def bar(max)
              o = @chars.first * ((max * @rate).ceil)   # "||||"
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

            def rate(x)
              r = case x
                  when Fixnum ; x / 100.0
                  when Float  ; x
                  when Array  ; (v, a) = x; rate(v.to_f/a)
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

      def self.strip(string)
        string.gsub(/\x1B\[[0-9;]*[mK]/, '')
      end

      include Fore
      extend  Fore
    end
  end
end
