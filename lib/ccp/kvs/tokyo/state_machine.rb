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

        LOCKED_BY = proc{|c| Array(c).select{|i| i !~ %r{/ruby/[^/]+/gems/}}[0,5].join("\n") || c rescue c}

        def state
          @state || CLOSED
        end

        def locker_info
          if CONNECTIONS[@source]
            return LOCKED_BY[CONNECTIONS[@source]]
          end

          target = File.basename(@source)
          CONNECTIONS.each_pair do |file, reason|
            return LOCKED_BY[reason] if File.basename(file) == target
          end

          if CONNECTIONS.any?
            return CONNECTIONS.inspect
          else
            return 'no brockers. maybe locked by other systems?'
          end
        end

        def open(mode, locker = nil)
          Pathname(@source.to_s).parent.mkpath

          # open and mark filename for threading error
          if @db.open(@source.to_s, mode)
            locker ||= (caller rescue "???")
            STDERR.puts "LOCK: #{@source} by [#{LOCKED_BY[locker]}]" if @debug
            CONNECTIONS[@db.path.to_s] = locker
          elsif threading_error?
            raise Tokyo::Locked, "%s is locked by [%s]" % [@source, locker_info]
          else
            tokyo_error!("%s#open(%s,%s): " % [self.class, @source, mode])
          end
        end

        def __close__(locker = nil)
          @db.close
          CONNECTIONS[@db.path] = nil
          STDERR.puts "UNLOCK: #{@source} by [#{LOCKED_BY[locker || caller]}]" if @debug
        end

        def close(locker = nil)
          C!(locker)
        end

        def C!(locker = nil)
          case state
          when CLOSED   ; # NOP
          when READABLE,
               WRITABLE ; __close__(locker); @state = CLOSED
          else          ; raise "unknown state: #{state}"
          end
        end

        def R!(locker = nil)
          case state
          when CLOSED   ; open(HDB::OREADER, locker); @state = READABLE
          when READABLE ; # NOP
          when WRITABLE ; # NOP
          else          ; raise "unknown state: #{state}"
          end
        end

        def W!(locker = nil)
          case state
          when CLOSED   ; open(HDB::OCREAT | HDB::OWRITER, locker); @state = WRITABLE
          when READABLE ; C!(locker); W!(locker)
          when WRITABLE ; # NOP
          else          ; raise "unknown state: #{state}"
          end
        end

        def R(locker = nil, &block)
          case state
          when CLOSED   ; begin; R!(locker); yield; ensure; close(locker); end
          when READABLE ; yield
          when WRITABLE ; yield
          else          ; raise "unknown state: #{state}"
          end
        end

        def W(locker = nil, &block)
          case state
          when CLOSED   ; begin; W!(locker); yield; ensure; close(locker); end
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
