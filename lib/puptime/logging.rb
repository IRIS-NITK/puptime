# frozen_string_literal: true

require "logger"

module Puptime
  #:nodoc:
  module Logging
    DEFAULT_LOG_FILEPATH = File.expand_path("~/.puptime/server.log").freeze

    def info(service_name:, service_message: nil)
      Puptime::Logging.logger.info build_message(service_name, service_message)
    end

    def warn(service_name:, service_message: nil)
      Puptime::Logging.logger.warn build_message(service_name, service_message)
    end

    def error(service_name:, service_message: nil)
      Puptime::Logging.logger.error build_message(service_name, service_message)
    end

    def self.setup_logger(log_filepath: DEFAULT_LOG_FILEPATH, log_level: Logger::WARN)
      @file_path = log_filepath
      @logger = Logger.new(log_filepath, 'weekly')
      @logger.level = log_level
      @logger.datetime_format = "%d/%b/%Y:%H:%M:%S %z"

      @logger.formatter = proc do |severity, datetime, _, msg|
        "#{severity} [#{datetime}] #{msg}"
      end
    end

    def self.reset
      @logger.close if @logger
      @logger = nil
      File.delete(@file_path)
    end

    private

      def self.logger
        @logger ||= setup_logger($stdout)
      end

      def build_message(service_name, service_message)
        if service_message
          "#{service_name} #{service_message}\n"
        else
          "#{service_name}\n"
        end
      end
  end
end
