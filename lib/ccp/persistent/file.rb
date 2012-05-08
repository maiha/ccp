# -*- coding: utf-8 -*-

class Ccp::Persistent::File < Ccp::Persistent::Base
  def self.ext
    ""
  end

  def initialize(source, serializer)
    @serializer = Ccp::Serializers.lookup(serializer)
    @source     = File.extname(source) == ".#{ext}" ? source : "#{source}.#{ext}"
  end

  def exist?(key)
    read.has_key?(key.to_s)
  end

  def load!(key)
    hash = read
    if hash.has_key?(key.to_s)
      hash[key.to_s]
    else
      raise Ccp::Persistent::NotFound, key.to_s
    end
  end

  def load(key)
    load!(key)
  rescue Ccp::Persistent::NotFound
    nil
  end

  def []=(key, val)
    hash = read
    hash[key.to_s] = val
    raw_write(encode(hash))
  end

  def keys
    read.keys.sort
  end

  def truncate
    File.unlink(path.to_s)
  end

  def path
    @path ||= Pathname(@source)
  end

  def read
    path.exist? ? decode(path.read{}).must(Hash) : {}
  end

  private
    def raw_write(buf)
      path.parent.mkpath
      path.open("w+"){|f| f.print buf}
    end
end
