class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.column :content, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :user_id, :int
    end
  end

  def self.down
    drop_table :tickets
  end
end
