class AddReplies < ActiveRecord::Migration
  def self.up
    add_column :tickets, :reply_id, :integer
  end

  def self.down
    remove_column :tickets, :reply_id
  end
end
