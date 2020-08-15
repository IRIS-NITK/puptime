# frozen_string_literal: true

require 'msteams-ruby-client'

module Puptime
  class Notifier
    # Email notifier
    class Teams < Puptime::Notifier::Base
      include Puptime::Logging

      def initialize(message, configuration)
        @channel = Teams.new(configuration["webhook_url"])
        super(message)
      end

      def send
        @channel.post(@message, title: 'Puptime Notification')
        info service_name: "MS Teams", service_message: @message
      end
    end
  end
end
