# frozen_string_literal: true

# Services table
class AddServicesTable < ActiveRecord::Migration[5.2]
  def self.up
    create_table :services do |t|
      t.string :name, null: false
      t.string :group
      t.string :service_type, null: false
      t.string :interval, null: false
      t.integer :error_level, null: false, default: 0
      t.string :address
      t.string :custom1
      t.string :custom2
      t.text :misc
      t.index :name
      t.index :group
      t.index :type
      t.index :interval
    end
  end

  def self.down
    drop_table :services
  end
end
