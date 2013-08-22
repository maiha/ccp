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
            return v
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
          @db[k.to_s] = v.to_s or tokyo_error!("set(%s): " % k)
        end

        def del(k)
          tryW("del")
          v = get(k)
          if v
            if @db.delete(k.to_s) 
              return v
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

      end
    end
  end
end
