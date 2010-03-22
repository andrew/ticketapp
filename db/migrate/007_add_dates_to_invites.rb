class AddDatesToInvites < ActiveRecord::Migration
  def self.up
    add_column :invites, :created_at, :datetime
    add_column :invites, :updated_at, :datetime
  end

  def self.down
    remove_column :invites, :created_at
    remove_column :invites, :updated_at
  end
end
