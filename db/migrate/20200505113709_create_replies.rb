class CreateReplies < ActiveRecord::Migration[6.0]
  def change
    create_table :replies do |t|
      t.integer :sended_user_id
      t.integer :received_user_id

      t.timestamps
    end
    add_index :replies, :sended_user_id
    add_index :replies, :received_user_id
  end
end
