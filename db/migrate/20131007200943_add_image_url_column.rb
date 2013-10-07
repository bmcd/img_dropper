class AddImageUrlColumn < ActiveRecord::Migration
  def up
    add_column :images, :image_remote_url, :string
  end

  def down
    remove_column :images, :image_remote_url
  end
end
