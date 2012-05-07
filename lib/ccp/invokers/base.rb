require 'logger'

module Ccp
  module Invokers
    class Base
      include Commands::Composite

      dsl_accessor :receiver, Receivers::Base
      dsl_accessor :profile , false
      dsl_accessor :comment , true
      dsl_accessor :logger  , proc{ Logger.new($stderr) }

      dsl_accessor :builtin_options, :default => {:profile => profile, :comment => comment, :logger => logger}
      dsl_accessor :default_options, :default => {}

      ######################################################################
      ### Class Methods

      def self.execute(options = {}, &block)
        cmd = new(options)
        cmd.instance_eval(&block) if block_given?
        cmd.receiver.execute(cmd)
        return cmd
      end

      ######################################################################
      ### Instance Methods

      def initialize(options = {})
        self.receiver = options.delete(:receiver) || self.class.receiver.new
        receiver.parse!(:fixture_keys => self.class.builtin_options.keys.map{|i| "!#{i}"})
        receiver.parse!(options)
        receiver.data.default.merge!(self.class.builtin_options)
        receiver.data.default.merge!(self.class.default_options)
      end

      def after
        receiver.show_profiles if data?(:profile)
        receiver.show_comments if data?(:comment)
      end
    end
  end
end
