# frozen_string_literal: true

# TCP table
class AddTcpTable < ActiveRecord::Migration[5.2]
  def self.up
    create_table :service_tcp do |t|
      t.integer :service_id, null: false
      t.string :message
      t.timestamps
      add_foreign_key :services, :service_tcp
    end
  end

  def self.down
    drop_table :service_tcp
  end
end
