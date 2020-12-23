# frozen_string_literal: true

module Puptime
  class Notifier
    # Base notifier class
    class Base
      attr_reader :message
      def initialize(message)
        @message = message
        notification = JSON.parse(File.read('teams.json'))
        notification["teams"]["text"] = @message
        notification["teams"]["error"] = Puptime::Service::Base.error_level
        File.write('./teams.json', JSON.pretty_generate(notification))
      end
    end
  end
end
