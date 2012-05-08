module Ccp::Persistent
  NotFound = Class.new(RuntimeError)

  autoload :Base     , 'ccp/persistent/base'
  autoload :Dir      , 'ccp/persistent/dir'
  autoload :File     , 'ccp/persistent/file'
  autoload :Json     , 'ccp/persistent/json'
  autoload :Tsv      , 'ccp/persistent/tsv'
  autoload :Versioned, 'ccp/persistent/versioned'
  autoload :Loadable , 'ccp/persistent/loadable'

  extend Ccp::Persistent::Loadable

  def self.lookup(name)
    case name.to_s
    when "dir"   ; Ccp::Persistent::Dir
    when "tsv"   ; Ccp::Persistent::Tsv
    when "file"  ; Ccp::Persistent::File
    when "json"  ; Ccp::Persistent::Json
    else
      name.must(Ccp::Persistent::Base) {
        raise NotFound, "%s: %s" % [name.class, name]
      }
    end
  end
end
