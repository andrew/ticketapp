class CreateBackgrounds < ActiveRecord::Migration
  def self.up
    create_table :backgrounds do |t|
      t.column :data, :binary, :size => 10_000_000, :null => false
      
      t.column :color, :string
      t.column :tile, :boolean
      t.column :active, :boolean
      
      t.column :user_id, :integer
      
      #Add other fields here
      #  t.column :name, :string
    end
    #execute "ALTER TABLE `backgrounds` MODIFY `data` MEDIUMBLOB"
  end

  def self.down
    drop_table :backgrounds
  end
end
