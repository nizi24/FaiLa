class AddUniqueNameUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :unique_name, :string
    add_index :users, :unique_name, unique: true
  end
end
