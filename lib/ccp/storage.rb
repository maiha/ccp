module Ccp
  class Storage
    NotFound = Class.new(RuntimeError)

    def self.load(path)
      array = path.to_s.split(".")
      kvs   = Ccp::Kvs[array.pop]
      codec = Ccp::Serializers[array.pop]
      return new(path, kvs, codec)
    end

    attr_reader :source, :kvs, :codec, :path
    delegate :get, :set, :del, :keys, :read, :to=>"@kvs"

    def initialize(source, kvs, codec)
      @source = source
      @codec  = codec
      @path   = Pathname(source)
      @kvs    = kvs.new(source).codec!(codec)
      @tables = {}
    end

    ######################################################################
    ### meta kvs

    def table_names
      tables                    # force to update @tables
      @tables.keys
    end

    def tables
      files = Dir.chdir(@path) { Dir["**/*.#{@kvs.ext}"] }
      files.map{|file|
        name = file.sub(/(\.#{@codec.ext})?(\.#{@kvs.ext})?$/, '')
        table(name, file)
      }
    end

    def table(name, file = nil)
      @tables[name.to_s] ||= (
        file ||= "%s.%s.%s" % [name, @codec.ext, @kvs.ext]
        @kvs.class.new((@path + file).to_s).codec!(@codec)
      )
    end

    def close_table(name)
      t = @tables[name.to_s]
      if t && t.close
        @tables.delete(name.to_s)
        true
      else
        false
      end
    end

    def close
      @tables.each_pair do |_,kvs|
        kvs.close
      end
      @tables = {}
    end

    ######################################################################
    ### kvs

    def read
      if @path.directory?
        tables
        hash = {}
        @tables.each_pair do |k, kvs|
          hash[k] = kvs.read
        end
        return hash
      else
        return @kvs.read
      end
    end
  end
end
