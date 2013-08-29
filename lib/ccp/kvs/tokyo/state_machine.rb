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

        def locker_info
          pretty = proc{|c| Array(c).find{|i| i !~ %r{/ruby/[^/]+/gems/}} || c}

          if CONNECTIONS[@source]
            return pretty[CONNECTIONS[@source]]
          end

          target = File.basename(@source)
          CONNECTIONS.each_pair do |file, reason|
            return pretty[reason] if File.basename(file) == target
          end

          if CONNECTIONS.any?
            return CONNECTIONS.inspect
          else
            return 'no brockers. maybe locked by other systems?'
          end
        end

        def open(mode)
          Pathname(@source.to_s).parent.mkpath

          # open and mark filename for threading error
          if @db.open(@source.to_s, mode)
            CONNECTIONS[@db.path.to_s] = (caller rescue "???")
          elsif threading_error?
            raise Tokyo::Locked, "%s is locked by %s" % [@source, locker_info]
          else
            tokyo_error!("%s#open(%s,%s): " % [self.class, @source, mode])
          end
        end

        def __close__
          @db.close
          CONNECTIONS[@db.path] = nil
        end

        def close
          C!
        end

        def C!
          case state
          when CLOSED   ; # NOP
          when READABLE,
               WRITABLE ; __close__; @state = CLOSED
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
            # TODO: close -> W -> close -> R ???
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
