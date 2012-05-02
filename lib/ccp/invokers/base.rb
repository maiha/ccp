require 'logger'

module Ccp
  module Invokers
    class Base
      include Commands::Composite

      dsl_accessor :receiver, Receivers::Base
      dsl_accessor :profile , false
      dsl_accessor :comment , true
      dsl_accessor :logger  , proc{ Logger.new($stderr) }

      ######################################################################
      ### Class Methods

      def self.execute(options = {}, &block)
        cmd = new(options)
        cmd.instance_eval(&block) if block_given?
        cmd.receiver.execute(cmd)
        return cmd
      end

      def self.default_options
        {:profile => profile, :comment => comment, :logger => logger}
      end

      ######################################################################
      ### Instance Methods

      def initialize(options = {})
        self.receiver = options.delete(:receiver) || self.class.receiver.new
        receiver.data.default.merge!(self.class.default_options)
        receiver.data.merge!(options)
      end

      def after
        receiver.show_profiles if data?(:profile)
        receiver.show_comments if data?(:comment)
      end
    end
  end
end
