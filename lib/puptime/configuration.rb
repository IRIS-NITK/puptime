# frozen_string_literal: true

require "yaml"

module Puptime
  #:nodoc:
  class Configuration
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

      @config = parse_config(file)
      @config.freeze
    end

  private

    def parse_config(file)
      YAML.load_file(file)
    rescue Psych::SyntaxError => e
      puts "YAML config parse error: #{e}"
      exit(100)
    end
  end
end
