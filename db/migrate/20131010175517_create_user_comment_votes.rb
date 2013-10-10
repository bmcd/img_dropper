class CreateUserCommentVotes < ActiveRecord::Migration
  def change
    create_table :user_comment_votes do |t|
      t.references :user, null: false
      t.references :comment, null: false
      t.integer :vote, null: false

      t.timestamps
    end
    add_index :user_comment_votes, [:user_id, :comment_id], unique: true
  end
end
