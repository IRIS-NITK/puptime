# frozen_string_literal: true

module Puptime
  #:no_doc:
  class Notifier
    autoload :Base,  "puptime/notifier/base"
    autoload :Email, "puptime/notifier/email"
    autoload :Teams, "puptime/notifier/notification"

    # Missing parameter
    class ParamMissingError < StandardError
      def initialize(error)
        super("Missing parameter error: #{error}")
      end
    end

    # Validation errors
    class ValidationError < StandardError
      def initialize(error)
        super("Validation for given configuration failed: #{error}")
      end
    end
  end
end
