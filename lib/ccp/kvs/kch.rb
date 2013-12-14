begin
  require 'kyotocabinet'
rescue LoadError
  load_error = true
end

unless load_error
  require 'ccp/kvs/kyoto'

  module Ccp
    module Kvs
      class Kch < Kyoto::Cabinet
        # core
        def get(k)        ; R{ super }; end
        def set(k,v)      ; W{ super }; end
        def del(k)        ; W{ super }; end
        def count         ; R{ super }; end
        def read          ; R{ super }; end
        def write(h)      ; W{ super }; end
        def clear         ; W{ super }; end

        # enum
        def each(&b)      ; R{ super }; end
        def each_pair(&b) ; R{ super }; end
        def each_key(&b)  ; R{ super }; end
        def keys          ; R{ super }; end
        def first_key     ; R{ super }; end
        def first         ; R{ super }; end
      end
    end
  end

  Ccp::Kvs << Ccp::Kvs::Kch
end
