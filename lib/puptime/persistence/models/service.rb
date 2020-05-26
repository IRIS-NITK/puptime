# frozen_string_literal: true

db_config = YAML.load_file("lib/puptime/persistence/config/database.yml")["development"]
ActiveRecord::Base.establish_connection(db_config)

module Puptime
  class Persistence
    # Store services
    class Service < ActiveRecord::Base
      self.table_name = "services"

      has_many :services_dns, class_name: "Puptime::Persistence::Dns"
      has_many :services_tcp, class_name: "Puptime::Persistence::Tcp"
    end
  end
end
