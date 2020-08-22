# frozen_string_literal: true

require "logger"

module Puptime
  #:nodoc:
  module Logging
    LEVELS = {
      debug: Logger::DEBUG,
      info: Logger::INFO,
      warn: Logger::WARN,
      error: Logger::ERROR,
      fatal: Logger::FATAL
    }.freeze

    def log
      Puptime::Logging.logger
    end

    def self.setup_logger(logfile)
      @filepath = logfile
      @logger = Logger.new(logfile, 2, 10_485_760)
      @logger.level = Logger::INFO
      @logger.datetime_format = "%d/%b/%Y:%H:%M:%S %z"
      @logger.formatter = proc do |severity, datetime, _progname, msg|
        if msg.end_with?("\n")
          "[#{datetime}] - #{severity} - #{msg}"
        else
          "[#{datetime}] - #{severity} - #{msg}\n"
        end
      end
      @logger
    end

    def self.logger
      @logger ||= setup_logger($stdout)
    end

    def self.reset
      @logger.close if @logger
      @logger = nil
      File.delete(@filepath)
    end
  end
end
