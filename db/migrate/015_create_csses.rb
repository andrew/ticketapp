class CreateCsses < ActiveRecord::Migration
  def self.up
    create_table :csses do |t|
      t.column :body, :text
      t.column :user_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :csses
  end
end
