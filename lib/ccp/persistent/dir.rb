# -*- coding: utf-8 -*-

class Ccp::Persistent::Dir < Ccp::Persistent::Base
  def self.ext
    ""
  end

  def exist?(key)
    path_for(key).exist?
  end

  def load!(key)
    path = path_for(key)
    if path.exist?
      decode(path.read{})
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
    path_for(key).open("w+"){|f| f.print encode(val)}
  end

  def keys
    Dir["#{path}/*.#{ext}"].map{|i| File.basename(i, ".*")}.sort
  end

  def truncate
    Dir["#{path}/*.#{ext}"].each{|file| File.unlink(file)}
  end

  def path
    @path ||= Pathname(@source)
  end

  private
    def path_for(key, mkdir = true)
      path.mkpath if mkdir
      path + "#{key}.#{ext}"
    end
end