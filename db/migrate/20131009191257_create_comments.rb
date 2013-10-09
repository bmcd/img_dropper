class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.references :user, null: false
      t.integer :parent_comment_id
      t.references :image, null: false

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :image_id
    add_index :comments, :parent_comment_id
  end
end
