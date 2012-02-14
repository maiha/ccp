require 'logger'

module Ccp
  module Invokers
    class Base
      include Commands::Composite

      dsl_accessor :receiver, Receivers::Base
      delegate :show_profiles, :profiles, :to=>"receiver"
      delegate :show_comments, :comments, :to=>"receiver"

      DEFAULT_OPTIONS = {
        :profile => false,
        :comment => true,
        :logger  => Logger.new($stderr),
      }

      ######################################################################
      ### Class Methods

      def self.execute(options = {}, &block)
        cmd = new(options)
        if block_given?
          cmd.instance_eval(&block)
        end
        cmd.benchmark
        return cmd
      end

      def self.benchmark(options = {}, &block)
        execute({:profile => true}.merge(options), &block)
      end

      ######################################################################
      ### Instance Methods

      def initialize(options = nil)
        options ||= {}
        set_default_receiver(options[:receiver])
        set_default_options
        set_runtime_options(options)
      end

      def set_default_receiver(receiver)
        self.receiver = receiver || self.class.receiver.new
      end

      def set_default_options
        self.class::DEFAULT_OPTIONS.each_pair do |key,val|
          data.default[key] = val
        end
      end

      def set_runtime_options(options)
        options.each_pair do |key,val|
          data[key] = val
        end
      end

      def receiver
        @receiver.must(Receivers::Base)
      end

      def receiver=(value)
        @receiver = value.must(Receivers::Base)
      end

      def after
        show_profiles if data?(:profile)
        show_comments if data?(:comment)
      end
    end
  end
end
