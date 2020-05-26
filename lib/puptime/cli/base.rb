# frozen_string_literal: true

require "puptime"

module Puptime
  class CLI
    # Base class for common functionality for CLI tasks.
    class Base
      def initialize(cli, options = {})
        @cli = cli
        @options = options
      end
    end
  end
end
