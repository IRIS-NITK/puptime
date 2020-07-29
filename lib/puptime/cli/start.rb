# frozen_string_literal: true

require "puptime"
require "puptime/cli/stop"
require "active_record"

module Puptime
  # CLI class
  class CLI
    # This implements the command line start task to start the Puptime server:
    # $ puptime start
    class Start < Puptime::CLI::Base
      include Puptime::Logging

      def run
        serviceset = setup
        # setup_database
        trap "SIGINT" do
          Puptime::CLI::Stop.run(serviceset.services)
          exit 130
        end
        serviceset.run
        serviceset.services.first.scheduler.join
      end

    private

      def setup
        serviceset = setup_serviceset
        setup_notifier
        @cli.say("Starting puptime!", :green)
        serviceset
      end

      def setup_serviceset
        @config = read_configuration

        set_pid
        setup_logging
        prepare_serviceset
      end

      def read_configuration
        Puptime::Configuration.new(file: @options[:config_file]).config
      rescue Puptime::Configuration::MissingFileError => e
        raise Puptime::CLI::Error.new(@cli, e.message)
      end

      def setup_logging
        log_file = File.expand_path(@config['log_file'] || "~/.puptime/server.log").freeze
        Puptime::Logging.setup_logger(log_file)
      end

      def set_pid
        pid_file = File.expand_path(@config['pid_file'] || "~/.puptime/pid.log").freeze
        File.open(pid_file, "w") {|file| file.write(Process.pid) }
      end

      def prepare_serviceset
        Puptime::ServiceSet.new(@config["monitors"])
      end

      def setup_notifier
        notifier = Puptime::NotificationQueue.instance(@config["notifications"])
        notifier.notification_consumer
      end
    end
  end
end
