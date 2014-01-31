module Ccp
  module Receivers
    class Base
      include Core
      include Loggable
      include Settings
      include Variables
      include Commentable

      # for execute
      include Executable
      include Profileable
      include Aroundable
      include Skippable
      include Fixtures

      # ensure to call '#setup' for module initializations
      def self.new(*args) r = super; r.setup; r; end
    end
  end
end
