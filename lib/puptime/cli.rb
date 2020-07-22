# frozen_string_literal: true

require "puptime"
require "thor"
require "thor/error"

module Puptime
  #:nodoc:
  class CLI < Thor
    autoload :Base,  "puptime/cli/base"
    autoload :Start, "puptime/cli/start"
    autoload :Stop,  "puptime/cli/stop"

    # Thor::Error for the CLI, which colors the message red.
    class Error < Thor::Error
      def initialize(cli, message)
        super(cli.set_color(message, :red))
      end
    end

    def self.exit_on_failure?
      true
    end

    def self.start(args = ARGV)
      help_flags = %w[-h --help]

      if args.any? {|a| help_flags.include?(a) }
        super(%w[help] + args.reject {|a| help_flags.include?(a) })
      else
        super
      end
    end

    desc "start", "Starts your puptime monitors"
    method_option :config_file, type: :string, default: Puptime::Configuration::DEFAULT_FILE, desc: "Config file to load when starting"
    def start
      Puptime::CLI::Start.new(self, options).run
    end

    desc "version", "Prints puptime version information"
    def version
      say "Puptime version #{Puptime::VERSION}"
    end
    map %w[-v --version] => :version

    def help(command = nil)
      command ||= "readme"
      page = manpage(command)

      if page
        print File.read(page)
      else
        super
      end
    end

  private

    def manpage(command)
      page = File.expand_path("../../../man/puptime-#{command}.md", __FILE__)
      return page if File.file?(page)

      nil
    end
  end
end
