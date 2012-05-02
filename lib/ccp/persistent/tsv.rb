# -*- coding: utf-8 -*-

class Ccp::Persistent::Tsv < Ccp::Persistent::Dir
  def self.ext
    "tsv"
  end

  def load_tsv(path)
    hash = {}
    path.readlines.each_with_index do |line, i|
      no = i+1
      key, val = line.split(/\t/,2)
      unless val
        $stderr.puts "#{self.class}#load_tsv: value not found. key='#{key}' (line: #{no})"
        next
      end
      obj = decode(val)
      hash[key] = obj
    end

    return hash
  end

  def save_tsv(f, hash)
    keys = hash.keys
    keys =
      case keys.first
      when NilClass ; return
      when Symbol   ; keys
      when /\A\d+\Z/; keys.sort_by(&:to_i)
      when String   ; keys.sort
      else          ; keys
      end

    keys.each do |key|
      f.puts "%s\t%s\n" % [key, encode(hash[key])]
    end
  end

  def load!(key)
    path = path_for(key)
    if path.exist?
      super
    elsif (tsv = tsv_path_for(key)).exist?
      load_tsv(tsv)
    else
      super
    end
  end

  def []=(key, val)
    # Now, tsv can manage only hash
    case val
    when Hash
      tsv_path_for(key).open("w+"){|f| save_tsv(f, val)}
    else
      super
    end
  end

  def files
    Dir["#{path}/*.#{ext}"] + Dir["#{path}/*.#{ext}.#{self.class.ext}"]
  end

  def keys
    files.map{|i| File.basename(i).split(".").first}.sort
  end

  def truncate
    files.each{|file| File.unlink(file)}
  end

  def tsv_path_for(key)
    Pathname(path_for(key).to_s + ".tsv")
  end
end
