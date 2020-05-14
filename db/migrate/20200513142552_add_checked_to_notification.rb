class AddCheckedToNotification < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :checked, :boolean, default: false
  end
end
