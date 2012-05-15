# -*- coding: utf-8 -*-

class Ccp::Persistent::Versioned
  attr_reader :path

  Storage = Struct.new(:dir, :name, :ext, :kvs)
  class Storage
    def self.complete(file, default_dir, default_kvs, default_ext)
      s = file.must(Storage) {
        path, ext, kvs = file.to_s.split(".", 3)
        new(default_dir, path, ext, kvs)
      }

      s.name = Pathname(s.name).basename(".*").to_s
      s.dir  = default_dir if s.dir.blank?
      s.ext  = default_ext if s.ext.blank?
      s.kvs  = default_kvs if s.kvs.blank?

      s.ext.must.not.blank
      s.kvs.must.not.blank

      return s
    end

    def path
      kvs = Ccp::Persistent.lookup(self.kvs)
      ext = Ccp::Serializers.lookup(self.ext)
      base = [name.to_s, ext.ext, kvs.ext].join(".").sub(/\.$/,'')
      return Pathname(dir) + base
    end

    def create
      kvs = Ccp::Persistent.lookup(self.kvs)
      ext = Ccp::Serializers.lookup(self.ext)
      kvs.new(path, ext)
    end
  end

  module StorageScanner
    def scan(dir)
      files = Dir.chdir(dir){
        Dir["*"].grep(/^(\d+)\./).sort{|a,b|
          [a.to_i, File.mtime(a)] <=> [b.to_i, File.mtime(b)]
        }
      }
    end

    extend self
  end

  attr_reader :kvs
  attr_reader :ext

  def initialize(dir, options = {})
    @path     = Pathname(dir)
    @kvs      = options[:kvs] || :dir
    @ext      = options[:ext] || :json
    @storages = {}

    @path.mkpath
  end

  # 最新のストレージを返す。存在しなければnil
  def latest
    storage = StorageScanner.scan(path).last
    storage ? self[storage] : nil
  end

  # 最新のストレージを返す。存在しなければ例外
  def latest!
    latest.must.exist { raise Ccp::Persistent::NotFound, "#{path}/*" }
  end      

  # 最新のストレージを返す。存在しなければ作成
  def default
    latest || now
  end

  # 現在の時刻で新しいストレージを作成して返す
  def now
    self[Time.now.to_i]
  end

  # 指定したストレージを返す。存在しなければ作成して返す
  def [](key)
    storage = Storage.complete(key, path, @kvs, @ext)
    @storages[storage.to_s] ||= storage.create
  end

  def inspect
    "<Kvs::Versioned dir=#{path} kvs=#{@kvs} ext=#{@ext}>"
  end
end
