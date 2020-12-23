# frozen_string_literal: true

module Puptime
  class Notifier
    # Base notifier class
    class Base
      attr_reader :message
      def initialize(message)
        @message = message
        error = Puptime::Service::Base.error_level
        @message += "Error Level #{error} "
        notification = JSON.parse(File.read('teams.json'))
        notification["teams"]["text"] = @message
        File.write('./teams.json', JSON.pretty_generate(notification))
      end
    end
  end
end
