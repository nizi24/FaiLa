class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.integer :received_user_id
      t.integer :action_user_id
      t.string :message
      t.string :link

      t.timestamps
    end
    add_index :notifications, :received_user_id
    add_index :notifications, :action_user_id
  end
end
