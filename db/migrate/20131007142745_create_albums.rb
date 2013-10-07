class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :title, null: false
      t.references :user

      t.timestamps
    end
    add_index :albums, :user_id
  end
end
