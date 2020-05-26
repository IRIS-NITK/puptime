# frozen_string_literal: true

module Puptime
  class Notifier
    # Base notifier class
    class Base
      attr_reader :message
      def initialize(message)
        @message = message
      end
    end
  end
end
