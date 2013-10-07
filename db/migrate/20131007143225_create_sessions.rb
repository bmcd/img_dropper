class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.string :session_token, null: false
      t.references :user

      t.timestamps
    end
    add_index :sessions, [:user_id, :session_token], unique: true
  end
end
