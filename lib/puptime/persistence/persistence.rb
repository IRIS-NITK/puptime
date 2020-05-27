# frozen_string_literal: true

require "active_record"
require "sqlite3"

module Puptime
  # Persistence
  class Persistence < ActiveRecord::Base
    autoload :Service, "puptime/persistence/models/service"
    autoload :Tcp, "puptime/persistence/models/services/tcp"
    autoload :Dns, "puptime/persistence/models/services/dns"
  end
end
