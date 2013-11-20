module Ccp
  module Kvs
    module Kyoto
      class Base
        include Ccp::Kvs::Core
        include KyotoCabinet

        ######################################################################
        ### info

        def info
          raise "not implemented yet"
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

            if kyoto_error?
              raise "tc already error before atomic: #{@db.ecode}"
            end
            v = block.call
            kyoto_error! if kyoto_error?
            return v
          end

          def kyoto_error!(label = nil)
            raise Ccp::Kvs::Kyoto::Error, "%s%s (%s)" % [label, error_message, @source]
          end

          def kyoto_error?
            @db.error.is_a?(KyotoCabinet::Error::XSUCCESS)
          end

          def threading_error?
            false
          end

          def error_message
            if @db
              @db.error
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
