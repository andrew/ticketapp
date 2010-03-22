class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.column :data, :binary, :size => 10_000_000, :null => false
      t.column :photoable_id,   :integer
      t.column :photoable_type, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      #Add other fields here
      #  t.column :name, :string
    end
    #execute "ALTER TABLE `photos` MODIFY `data` MEDIUMBLOB"
  end

  def self.down
    drop_table :photos
  end
end
