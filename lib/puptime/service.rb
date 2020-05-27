# frozen_string_literal: true

require "rufus-scheduler"
module Puptime
  #:no_doc:
  class Service
    autoload :Base,  "puptime/service/base"
    autoload :TCP,   "puptime/service/tcp"
    autoload :DNS,   "puptime/service/dns"
    autoload :Redis, "puptime/service/redis"
    autoload :HTTP,  "puptime/service/http"

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
