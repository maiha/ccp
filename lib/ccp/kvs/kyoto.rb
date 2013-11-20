require 'kyotocabinet'

module Ccp
  module Kvs
    module Kyoto
      Error  = Class.new(Ccp::Kvs::Error)
      Locked = Class.new(Error)

      CONNECTIONS = {}
    end
  end
end

require 'ccp/kvs/kyoto/base'
require 'ccp/kvs/kyoto/state_machine'
require 'ccp/kvs/kyoto/cabinet'

