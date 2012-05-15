# -*- coding: utf-8 -*-

module Ccp::Persistent::Loadable
  def load(file)
    ext = Ccp::Serializers.lookup(Pathname(file).extname.to_s.delete("."))
    kvs = load_kvs_lookup_by_filename(file)
    kvs.new(file.sub(%r{/$},''), ext)
  end

  private
    def load_kvs_lookup_by_filename(file)
      return Ccp::Persistent::Dir if File.directory?(file.to_s)
      case file.to_s
      when %r{/$}    ; Ccp::Persistent::Dir
      when %r{\.tsv$}; Ccp::Persistent::Tsv
      else           ; Ccp::Persistent::File
      end
    end
end
