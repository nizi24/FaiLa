class AddColumnToContact < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :email, :string
  end
end
