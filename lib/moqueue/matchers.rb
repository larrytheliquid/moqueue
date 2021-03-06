module Moqueue
  module Matchers
    
    class HasReceived
      
      def initialize(expected_msg)
        @expected_msg = expected_msg
      end
      
      def matches?(queue)
        if queue.respond_to?(:received_message?)
          @queue = queue
          @queue.received_message?(@expected_msg)
        else
          raise NoMethodError, 
          "Grrr. you can't use ``should have_received_message'' on #{queue.inspect} " +
          "because it doesn't respond_to :received_message?"
        end
      end
      
      def failure_message_for_should
        "expected #{@queue.inspect} to have received message ``#{@expected_msg}''"
      end

      def failure_message_for_should_not
        "expected #{@queue.inspect} to not have received message ``#{@expected_msg}''"
      end

    end
    
    class HasAcked
      
      def initialize(msg_expecting_ack)
        @msg_expecting_ack = msg_expecting_ack
      end
      
      def matches?(queue_or_exchange)
        if queue_or_exchange.respond_to?(:received_ack_for_message?)
          @queue_or_exchange = queue_or_exchange
          @queue_or_exchange.received_ack_for_message?(@msg_expecting_ack)
        else
          raise NoMethodError,
          "Grrr. you can't use ``should have_received_ack_for'' on #{queue_or_exchange.inspect} " +
          "because it doesn't respond_to :received_ack_for_message?"
        end
      end
      
      def failure_message_for_should
        "expected #{@queue_or_exchange.inspect} to have received an ack for the message ``#{@msg_expecting_ack}''"
      end
      
      def failure_message_for_should_not
        "expected #{@queue_or_exchange.inspect} to not have received an ack for the message ``#{@msg_expecting_ack}''"
      end
    end
    
    def have_received_message(expected_msg)
      HasReceived.new(expected_msg)
    end
    
    def have_received_ack_for(expected_msg)
      HasAcked.new(expected_msg)
    end
    
    alias_method :have_received, :have_received_message
    alias_method :have_ack_for, :have_received_ack_for
  end
end

if defined?(::Spec::Runner)
  Spec::Runner.configure do |config|
    config.include(::Moqueue::Matchers)
  end
end