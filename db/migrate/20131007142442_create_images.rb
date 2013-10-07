class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :title
      t.text :description
      t.references :user

      t.timestamps
    end
    add_index :images, :user_id

    add_attachment :images, :image
  end
end
