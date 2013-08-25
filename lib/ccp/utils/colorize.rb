module Ccp
  module Utils
    module Colorize
      # [examples]
      # Ccp::Utils::Colorize::Fore.red("hello")
      # Ccp::Utils::Colorize::Back.red("hello")
      # Ccp::Utils::Colorize.red("hello")        # same as Fore

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

      include Fore
      extend  Fore
    end
  end
end
