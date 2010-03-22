class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.column :name, :string
      t.column :email, :string
      t.column :content, :text
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :resolved, :boolean, :default => false
    end
  end

  def self.down
    drop_table :feedbacks
  end
end
