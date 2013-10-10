class CreateUserImageVotes < ActiveRecord::Migration
  def change
    create_table :user_image_votes do |t|
      t.references :user, null: false
      t.references :image, null: false
      t.integer :vote, null: false

      t.timestamps
    end
    add_index :user_image_votes, [:user_id, :image_id], unique: true
  end
end
