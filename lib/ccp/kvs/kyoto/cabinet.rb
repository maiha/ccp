module Ccp
  module Kvs
    module Kyoto
      class Cabinet < Base
        include StateMachine

        def initialize(source)
          @source = source
          @db     = DB.new
        end

        ######################################################################
        ### kvs

        def get(k)
          tryR("get")
          v = @db[k.to_s]
          if v
            return decode(v)
          else
            if @db.error.is_a?(KyotoCabinet::Error::XNOREC)
              return nil
            else
              kyoto_error!("get(%s): " % k)
            end
          end
        end

        def set(k,v)
          tryW("set")
          val = encode(v)
          @db[k.to_s] = val or
            kyoto_error!("set(%s): " % k)
        end

        def del(k)
          tryW("del")
          v = @db[k.to_s]
          if v
            if @db.delete(k.to_s)
              return decode(v)
            else
              kyoto_error!("del(%s): " % k)
            end
          else
            return nil
          end
        end

        def exist?(k)
          tryR("exist?")
          return !! @db[k.to_s] # TODO: fast access
        end

        def count
          tryR("count")
          return @db.count
        end

        ######################################################################
        ### bulk operations (not DRY but fast)

        def read
          tryR("read")
          hash = {}
          @db.each do |k, v|
            v or kyoto_error!("each(%s): " % k)
            hash[k] = decode(v)
          end
          return hash
        end

        def write(h)
          tryW("write")
          h.each_pair do |k,v|
            val = encode(v)
            @db[k.to_s] = val or kyoto_error!("write(%s): " % k)
          end
          return h
        end

        ######################################################################
        ### iterator

        def each(&block)
          each_pair(&block)
        end

        def each_pair(&block)
          tryR("each_pair")

          # TODO: Waste memory! But kc ignores exceptions in his each block.
          array = []
          @db.each{|k, v| array << [k, decode(v)]} or kyoto_error!("each_pair: ")
          array.each do |a|
            block.call(a[0], a[1])
          end
        end

        def each_key(&block)
          tryR("each_key")

          # TODO: Waste memory! But kc ignores exceptions in his each block.
          array = []
          @db.each_key{|k| array << k.first} or kyoto_error!("each_key: ")
          array.each do |k|
            block.call(k)
          end
        end

        def keys
          tryR("keys")

          array = []
          each_key do |key|
            array << key
          end
          return array
        end

        def first_key
          first.first
        end

        def first
          tryR("first")
          @db.cursor_process {|cur|
            cur.jump
            k, v = cur.get(true)
            return [k, decode(v)]
          }
        end

      end
    end
  end
end
