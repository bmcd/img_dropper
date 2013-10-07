class CreateAlbumImages < ActiveRecord::Migration
  def change
    create_table :album_images do |t|
      t.references :image
      t.references :album

      t.timestamps
    end
    add_index :album_images, [:image_id, :album_id], unique: true
  end
end
