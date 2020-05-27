# frozen_string_literal: true

db_config = YAML.load_file("lib/puptime/persistence/config/database.yml")["development"]
ActiveRecord::Base.establish_connection(db_config)

module Puptime
  class Persistence
    # DNS Store
    class Dns < Puptime::Persistence
      self.table_name = "service_dns"

      belongs_to :service, class_name: "Puptime::Persistence::Service"
    end
  end
end
