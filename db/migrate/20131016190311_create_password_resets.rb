class CreatePasswordResets < ActiveRecord::Migration
  def change
    create_table :password_resets do |t|
      t.references :user, null: false
      t.string :token, null: false

      t.timestamps
    end
    add_index :password_resets, [:user_id, :token]
  end
end
