require 'tokyocabinet'

module Ccp
  module Kvs
    module Tokyo
      Error  = Class.new(Ccp::Kvs::Error)
      Locked = Class.new(Error)

      CONNECTIONS = {}
    end
  end
end

require 'ccp/kvs/tokyo/info'
require 'ccp/kvs/tokyo/base'
require 'ccp/kvs/tokyo/state_machine'
require 'ccp/kvs/tokyo/cabinet'

