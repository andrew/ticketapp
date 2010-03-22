class AddPrivateTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :private, :boolean, :default => false
    add_column :users, :privacy_default, :boolean, :default => false
  end

  def self.down
    remove_column :tickets, :private
    remove_column :users, :privacy_default
  end
end
