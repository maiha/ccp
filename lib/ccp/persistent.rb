module Ccp::Persistent
  NotFound = Class.new(RuntimeError)

  autoload :Base     , 'ccp/persistent/base'
  autoload :Dir      , 'ccp/persistent/dir'
  autoload :Tsv      , 'ccp/persistent/tsv'
  autoload :Versioned, 'ccp/persistent/versioned'

  def self.lookup(name)
    case name
    when :dir, "dir"   ; Ccp::Persistent::Dir
    when :tsv, "tsv"   ; Ccp::Persistent::Tsv
    else
      name.must(Ccp::Persistent::Base) {
        raise NotFound, "%s: %s" % [name.class, name]
      }
    end
  end
end
