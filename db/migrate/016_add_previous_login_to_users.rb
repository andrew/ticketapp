class AddPreviousLoginToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :previous_login, :datetime
  end

  def self.down
    remove_column :users, :previous_login
  end
end
