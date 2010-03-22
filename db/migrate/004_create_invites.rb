class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
      t.column :email, :string
      t.column :approved, :bool
      t.column :name, :string
      t.column :code, :string
    end
  end

  def self.down
    drop_table :invites
  end
end
