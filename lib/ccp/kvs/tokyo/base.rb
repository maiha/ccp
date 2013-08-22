module Ccp
  module Kvs
    module Tokyo
      class Base
        include Ccp::Kvs::Core
        include TokyoCabinet

        ######################################################################
        ### info

        def info
          if path.exist?
            Tokyo::Info.parse(`tcamgr inform #{path}`)
          else
            raise Ccp::Kvs::NotConnected, "%s(%s)" % [ self.class, @source]
          end
        end

        ######################################################################
        ### kvs

        def get(k)   ; @db[k]        ; end
        def set(k,v) ; @db[k] = v    ; end
        def del(k)   ; @db.delete(k) ; end

        def path
          file = @source.to_s.sub(/#.*$/, '') # parse "foo.tch#mode=r"
          Pathname(file)
        end

        private
          def tokyo_error!(label = nil)
            raise Ccp::Kvs::Tokyo::Error, "%s%s" % [label, error_message]
          end

          def error_message
            if @db
              # TODO: Where is adb_errmsg?
              "%s (%s)" % [@db.errmsg(@db.ecode).to_s, @db.ecode]
            else
              '[Not Initialized]'
            end
          rescue Exception => e
            "[BUG] #{e}"
          end
      end
    end
  end
end
