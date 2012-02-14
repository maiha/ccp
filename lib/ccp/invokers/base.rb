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
      }

      ######################################################################
      ### Instance Methods

      def initialize(options = nil)
        self.receiver = self.class.receiver.new
        self.class.prepend_command Commands::RuntimeArgs, options
        set_default_options
      end

      def set_default_options
        self.class::DEFAULT_OPTIONS.each_pair do |key,val|
          data.default[key] = val
        end
        data.default(:logger) { Logger.new($stderr) }
      end

      def benchmark
        before
        super
        after
        return true
      end

      def receiver
        @receiver.must(Receivers::Base)
      end

      def receiver=(value)
        @receiver = value.must(Receivers::Base)
      end

      private
        def before
        end

        def after
          show_profiles if data?(:profile)
          show_comments if data?(:comment)
        end
    end
  end
end
