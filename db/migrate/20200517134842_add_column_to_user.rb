class AddColumnToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :image_url, :string
  end
end
