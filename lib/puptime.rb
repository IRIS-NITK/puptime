# frozen_string_literal: true

#:nodoc:
module Puptime
  # Errors
  class Error < StandardError; end

  autoload :Configuration,     "puptime/configuration"
  autoload :CLI,               "puptime/cli"
  autoload :Logging,           "puptime/logging"
  autoload :NotificationQueue, "puptime/notification_queue"
  autoload :Notifier,          "puptime/notifier"
  autoload :Persistence,       "puptime/persistence/persistence"
  autoload :Service,           "puptime/service"
  autoload :ServiceSet,        "puptime/service_set"
  autoload :VERSION,           "puptime/version"

end
