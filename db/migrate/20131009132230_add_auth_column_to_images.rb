class AddAuthColumnToImages < ActiveRecord::Migration
  def up
    add_column :images, :authorization_token, :string
  end

  def down
    remove_column :images, :authorization_token
  end
end
