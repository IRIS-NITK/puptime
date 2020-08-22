# frozen_string_literal: true

require "yaml"
require "after_do"
require "pp"

module Puptime
  #:nodoc:
  class Configuration
    include Puptime::Logging
    extend AfterDo

    attr_accessor :config
    DEFAULT_FILE = File.expand_path("~/.puptime/config.yml").freeze

    # This error is thrown when a config file is explicitly specified that
    # doesn't exist.
    class MissingFileError < StandardError
      def initialize(file)
        super("Missing config file: #{file}")
      end
    end

    def initialize(file: nil)
      file ||= DEFAULT_FILE
      raise MissingFileError, file if file && !File.exist?(file)

      @config = parse_config(file).freeze
    end

    after :initialize do |*, config|
      config.log_update
    end

    def log_update
      log.info "Configuration updated!"
      log.info @config.pretty_inspect
    end

  private

    def parse_config(file)
      YAML.load_file(file)
    end
  end
end
