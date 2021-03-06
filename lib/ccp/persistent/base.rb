# -*- coding: utf-8 -*-

class Ccp::Persistent::Base
  attr_reader :source
  attr_reader :serializer

  delegate :ext, :encode, :decode, :to => :serializer

  def initialize(source, serializer)
    @source     = source
    @serializer = Ccp::Serializers.lookup(serializer)
  end

  def self.ext
    raise NotImplementedError, "subclass resposibility"
  end

  def exist?(key)
    raise NotImplementedError, "subclass resposibility"
  end

  def save(hash, keys = nil)
    (keys || hash.keys).each do |key|
      self[key] = hash[key]
    end
  end

  def load!(key)
    raise NotImplementedError, "subclass resposibility"
  end

  def load(key)
    raise NotImplementedError, "subclass resposibility"
  end

  def [](key)
    load!(key)
  end

  def []=(key, val)
    raise NotImplementedError, "subclass resposibility"
  end

  def read
    read!
  rescue Ccp::Persistent::NotFound
    {}
  end

  def read!
    keys.inject({}) {|h,k| h[k] = self[k]; h}
  end

  def keys
    raise NotImplementedError, "subclass resposibility"
  end

  def truncate
    raise NotImplementedError, "subclass resposibility"
  end
end
