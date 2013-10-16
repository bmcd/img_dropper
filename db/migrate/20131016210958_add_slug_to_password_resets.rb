class AddSlugToPasswordResets < ActiveRecord::Migration
  def change
    add_column :password_resets, :slug, :string
    add_index :password_resets, :slug, unique: true
  end
  
end
