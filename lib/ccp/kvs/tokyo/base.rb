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

        def path
          file = @source.to_s.sub(/#.*$/, '') # parse "foo.tch#mode=r"
          Pathname(file)
        end

        private
          # Check ecode and then raise. too boring... The library should implement this as atomic operation!
          def atomic(&block)
            raise NotImplementedError, "tc keep ecode until new erros occured"

            if tokyo_error?
              raise "tc already error before atomic: #{@db.ecode}"
            end
            v = block.call
            tokyo_error! if tokyo_error?
            return v
          end

          def tokyo_error!(label = nil)
            raise Ccp::Kvs::Tokyo::Error, "%s%s (%s)" % [label, error_message, @source]
          end

          def tokyo_error?
            @db.ecode != HDB::ESUCCESS
          end

          def threading_error?
            @db.ecode == HDB::ETHREAD
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
