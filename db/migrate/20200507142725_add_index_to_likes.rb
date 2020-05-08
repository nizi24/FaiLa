class AddIndexToLikes < ActiveRecord::Migration[6.0]
  def change
    remove_index :likes, [:likeable_type, :likeable_id]
    add_index :likes, [:user_id, :likeable_type, :likeable_id], unique: true
  end
end
