module Ccp
  module Commands
    module Receivable
      ######################################################################
      ### Receiver Methods

      def receiver
        (@receiver ||= Ccp::Receivers::Base.new).must(Receivers::Base)
      end

      def receiver=(value)
        return unless value
        @receiver = value.must(Ccp::Receivers::Base)
      end

      ######################################################################
      ### Delegate Methods

      delegate :data, :data?, :to=>"receiver"
    end
  end
end
