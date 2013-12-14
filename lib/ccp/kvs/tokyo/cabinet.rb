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

        def exist?(k)
          tryR("exist?")
          return @db.has_key?(k.to_s)
        end

        def count
          tryR("count")
          return @db.rnum
        end

        ######################################################################
        ### bulk operations (not DRY but fast)

        def read
          tryR("read")
          hash = {}
          @db.iterinit or tokyo_error!("read: ")
          while k = @db.iternext
            v = @db.get(k) or tokyo_error!("get(%s): " % k)
            hash[k] = decode(v)
          end
          return hash
        end

        def write(h)
          tryW("write")
          h.each_pair do |k,v|
            val = encode(v)
            @db[k.to_s] = val or tokyo_error!("write(%s): " % k)
          end
          return h
        end

        def clear
          tryW("clear")
          @db.clear or tokyo_error!("clear: ")
        end

        ######################################################################
        ### iterator

        def each(&block)
          each_pair(&block)
        end

        def each_pair(&block)
          each_key do |key|
            block.call(key, get(key))
          end
        end

        def each_key(&block)
          tryR("each_key")
          @db.iterinit or tokyo_error!("each_key: ")
          while key = @db.iternext
            block.call(key)
          end
        end

        def keys
          array = []
          each_key do |key|
            array << key
          end
          return array
        end

        def first_key
          tryR("first_key")
          @db.iterinit or tokyo_error!("first_key: ")
          return @db.iternext
        end

        def first
          key = first_key
          if key
            return [key, get(key)]
          else
            return nil
          end
        end

      end
    end
  end
end
