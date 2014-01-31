module Ccp
  module Invokers
    class Base
      include Commands::Composite
      include Utils::Options

      dsl_accessor :receiver, Receivers::Base

      dsl_accessor :default_options, :default => {}

      dsl_accessor :builtins, options(:profile, :comment, :logger)
      dsl_accessor :fixtures, options(:fixture_save, :fixture_keys, :fixture_dir, :fixture_kvs, :fixture_ext)

      profile false
      comment true
      logger  Logger.new(STDOUT)

      ######################################################################
      ### Class Methods

      def self.execute(options = {}, &block)
        cmd = new(options)
        cmd.instance_eval(&block) if block_given?
        cmd.receiver.execute(cmd)
        return cmd
      end

      def self.receiver_options
        opts = fixtures.options
        opts[:fixture_keys] ||= builtins.options.keys.map{|i| "!#{i}"}
        return opts
      end

      ######################################################################
      ### Instance Methods

      def initialize(options = {})
        self.receiver = options.delete(:receiver) || self.class.receiver.new
        receiver.parse!(self.class.receiver_options)
        receiver.parse!(options)
        receiver.data.default.merge!(self.class.builtins.options)
        receiver.data.default.merge!(self.class.default_options)
      end

      def after
        receiver.show_profiles if data?(:profile)
        receiver.show_comments if data?(:comment)
      end
    end
  end
end
