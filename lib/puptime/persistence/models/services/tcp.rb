# frozen_string_literal: true

db_config = YAML.load_file("lib/puptime/persistence/config/database.yml")["development"]
ActiveRecord::Base.establish_connection(db_config)

module Puptime
  class Persistence
    # TCP Persistence
    class Tcp < Puptime::Persistence
      self.table_name = "service_tcp"

      belongs_to :service, class_name: "Puptime::Persistence::Service"
    end
  end
end
