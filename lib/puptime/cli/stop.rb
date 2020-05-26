# frozen_string_literal: true

require "puptime"

module Puptime
  # CLI class
  class CLI
    # This implements the stop task to stop the Puptime server:
    class Stop < Puptime::CLI::Base
      include Puptime::Logging

      def self.run(services)
        puts "Gracefully shutting down"
        Puptime::Logging.reset
        services.each do |service|
          service.scheduler.shutdown(:kill)
        end
      end
    end
  end
end
