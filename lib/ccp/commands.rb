module Ccp
  module Commands
    autoload :CommandNotFound, 'ccp/commands/command_not_found'
    autoload :Composite      , 'ccp/commands/composite'
    autoload :Executable     , 'ccp/commands/executable'
    autoload :Receivable     , 'ccp/commands/receivable'
    autoload :RuntimeArgs    , 'ccp/commands/runtime_args'
    autoload :Commentable    , 'ccp/commands/commentable'
    autoload :Core           , 'ccp/commands/core'
    autoload :Base           , 'ccp/commands/base'
    autoload :Resolvable     , 'ccp/commands/resolvable'
  end
end
