class ChangeColumnReplies < ActiveRecord::Migration[6.0]
  def change
    remove_column :replies, :micropost_id, :integer

    add_column :replies, :sended_micropost_id, :integer
    add_column :replies, :received_micropost_id, :integer

    add_index :replies, :sended_micropost_id
    add_index :replies, :received_micropost_id
  end
end
