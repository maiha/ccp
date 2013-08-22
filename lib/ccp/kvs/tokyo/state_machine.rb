module Ccp
  module Kvs
    module Tokyo
      module StateMachine
        include TokyoCabinet

        ######################################################################
        ### state machine

        CLOSED   = 1
        READABLE = 2
        WRITABLE = 3

        def state
          @state || CLOSED
        end

        def open(mode)
          Pathname(@source.to_s).parent.mkpath
          @db.open(@source.to_s, mode) or tokyo_error!("%s#open(%s,%s): " % [self.class, @source, mode])
        end

        def close
          C!
        end

        def C!
          case state
          when CLOSED   ; # NOP
          when READABLE,
               WRITABLE ; @db.close; @state = CLOSED
          else          ; raise "unknown state: #{state}"
          end
        end

        def R!
          case state
          when CLOSED   ; open(HDB::OREADER); @state = READABLE
          when READABLE ; # NOP
          when WRITABLE ; # NOP
          else          ; raise "unknown state: #{state}"
          end
        end

        def W!
          case state
          when CLOSED   ; open(HDB::OCREAT | HDB::OWRITER); @state = WRITABLE
          when READABLE ; C!; W!()
          when WRITABLE ; # NOP
          else          ; raise "unknown state: #{state}"
          end
        end

        def R(&block)
          case state
          when CLOSED   ; begin; R!(); yield; ensure; close; end
          when READABLE ; yield
          when WRITABLE ; yield
          else          ; raise "unknown state: #{state}"
          end
        end

        def W(&block)
          case state
          when CLOSED   ; begin; W!(); yield; ensure; close; end
          when READABLE ; raise "reopen from read to write is not permitted"
          when WRITABLE ; yield
          else          ; raise "unknown state: #{state}"
          end
        end

        def touch
          W() {}
        end

        private
          def isReadable
            case state
            when CLOSED   ; false
            when READABLE ; true
            when WRITABLE ; true
            else          ; raise "unknown state: #{state}"
            end
          end

          def isWritable
            case state
            when CLOSED   ; false
            when READABLE ; false
            when WRITABLE ; true
            else          ; raise "unknown state: #{state}"
            end
          end

          def tryR(op)
            isReadable or raise NotAllowed, "use R! or R{tch.%s} (%s)" % [op, source]
          end

          def tryW(op)
            isWritable or raise NotAllowed, "use W! or W{tch.%s} (%s)" % [op, source]
          end
        
      end
    end
  end
end
