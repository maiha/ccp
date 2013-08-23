module Ccp
  module Kvs
    module Tokyo
      class Cabinet < Base
        include StateMachine

        def initialize(source)
          @source = source
          @db     = HDB.new
        end

        ######################################################################
        ### kvs

        def get(k)
          tryR("get")
          v = @db[k.to_s]
          if v
            return decode(v)
          else
            if @db.ecode == HDB::ENOREC
              return nil
            else
              tokyo_error!("get(%s): " % k)
            end
          end
        end

        def set(k,v)
          tryW("set")
          val = encode(v)
          @db[k.to_s] = val or
            tokyo_error!("set(%s): " % k)
        end

        def del(k)
          tryW("del")
          v = @db[k.to_s]
          if v
            if @db.delete(k.to_s)
              return decode(v)
            else
              tokyo_error!("del(%s): " % k)
            end
          else
            return nil
          end
        end

        def count
          tryR("count")
          return @db.rnum
        end

        ######################################################################
        ### iterator

        def each(&block)
          each_keys do |key|
            block.call(get(key))
          end
        end

        def each_pair(&block)
          each_keys do |key|
            block.call(key, get(key))
          end
        end

        def each_keys(&block)
          tryR("each_keys")
          @db.iterinit
          while key = @db.iternext
            block.call(key)
          end
        end

        def keys
          array = []
          each_keys do |key|
            array << key
          end
          return array
        end

      end
    end
  end
end
