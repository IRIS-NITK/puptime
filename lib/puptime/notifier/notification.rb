require 'net/http'
require 'openssl'
require 'uri'

module Puptime
  class Notifier
    class Teams < Puptime::Notifier::Base
      include Puptime::Logging

      def initialize(message = "", configuration = [])
        @channel = ::Teams.new(configuration["webhook_url"])
        super(message)
      end

      def send
        uri = URI.parse(@channel)
        request = Net::HTTP::Post.new(uri.request_uri)
        request['Content-Type'] = 'application/json'

        req = JSON.parse(File.read('teams.json'))
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.start {|h| h.request(req) }

        info service_name: "MS Teams", service_message: @message
      end
    end
  end
end
