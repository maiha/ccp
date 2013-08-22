module Ccp
  module Kvs
    module Tokyo
      class Info
        ######################################################################
        ### API

        dsl_accessor :path         , "to_s"
        dsl_accessor :database_type, "to_s"
        dsl_accessor :record_number, "to_i"
        dsl_accessor :size         , "to_i"

        def count; record_number; end

        ######################################################################
        ### example
        
        def self.example
          parse(<<-EOF)
      path: /tmp/tc/foo.tch
      database type: hash database
      record number: 0
      size: 528704
          EOF
        end

        ######################################################################
        ### parse
        
        def self.parse(buf)
          # % tcamgr inform /tmp/tc/foo.tch
          #
          # path: /tmp/tc/foo.tch
          # database type: hash database
          # record number: 0
          # size: 528704
          #

          info = new
          buf.scan(/^([a-z ]+): (.*?)($|\Z)/mo).each do |key, val|
            key = key.strip.tr(' ', '_')
            val = val.strip
            info[key] = val
          end
          return info
        end

        ######################################################################
        ### instance methods
        
        def initialize
          @hash = {}
        end

        def [](key)
          @hash[key]
        end

        def []=(key, val)
          @hash[key] = val
        end

        private
          def method_missing(key, *args, &block)
            raise unless args.empty?
            raise unless self.class.respond_to?(key)

            cast = self.class.__send__(key)
            return self[key.to_s].__send__(cast)
          end
      end
    end
  end
end
