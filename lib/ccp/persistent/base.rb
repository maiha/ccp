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

  def keys
    raise NotImplementedError, "subclass resposibility"
  end

  def truncate
    raise NotImplementedError, "subclass resposibility"
  end
end
