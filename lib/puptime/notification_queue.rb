# frozen_string_literal: true

module Puptime
  #:no_doc:
  class NotificationQueue
    CHANNELS = %w[teams email].freeze

    # Validation errors
    class ValidationError < StandardError
      def initialize(error)
        super("Validation for configuration failed: #{error}\nIs the given channel supported?")
      end
    end

    attr_reader :configuration

    @instance_mutex = Mutex.new

    private_class_method :new

    def initialize(configuration)
      raise ValidationError, configuration unless validate(configuration)

      @configuration = configuration
      @queue = Queue.new
      @consumer = nil
    end

    def enqueue_notification(message)
      @queue.push(message)
    end

    def notification_consumer
      @consumer = Thread.new { loop { process_notification } }
    end

    def self.instance(configuration)
      return @instance if @instance

      @instance_mutex.synchronize do
        @instance ||= new(configuration)
      end

      @instance
    end

  private

    def processed?
      @queue.empty?
    end

    def process_notification
      message = @queue.pop(non_block = false) # rubocop:disable Lint/UselessAssignment # Suspend the thread when queue is empty
      Puptime::Notifier::Email.new(message, @configuration.detect {|x| x["channel"] == "email" }).send
      Puptime::Notifier::Teams.new(message, @configuration.detect {|x| x["channel"] == "teams" }).send
    end

    def validate(configuration)
      channels = configuration.map {|x| x["channel"] }
      (CHANNELS & channels) == CHANNELS
    end
  end
end
