# frozen_string_literal: true

# DNS table
class AddDnsTable < ActiveRecord::Migration[5.2]
  def self.up
    create_table :service_dns do |t|
      t.integer :service_id, null: false
      t.string :message
      t.timestamps
      add_foreign_key :services, :service_dns
    end
  end

  def self.down
    drop_table :service_dns
  end
end
