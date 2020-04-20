class RemoveFirstNameAndLastNameFromUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string
    remove_column :users, :first_name, :string
    remove_column :users, :last_name, :string
  end
end
