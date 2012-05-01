module Ccp
  module Fixtures
    module Writers
      class Base
        def self.[]= (path, hash)
          new(hash,path).execute
        end

        def initialize(hash, path)
          @hash = hash.must(Hash)
          @path = path.must(Pathname)
        end

        def serialize(data)
          data
        end

        def write(data)
          @path.parent.mkpath
          @path.open("w+"){|f| f.print data}
        end

        def execute
          write(serialize(@hash))
        end
      end

      class YamlWriter < Base
        def serialize(data)
          YAML.dump(data)
        end
      end
    end
  end
end
