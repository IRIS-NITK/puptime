# frozen_string_literal: true

module Puptime
  class Notifier
    # Base notifier class
    class Base
      attr_reader :message
      def initialize(message)
        @message = message
      end

      def error_level
        error = Puptime::Service::Base.return_error_level
        @message += "Error level #{error}"
      end
    end
  end
end
