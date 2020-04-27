class ChangeColumnInLikes < ActiveRecord::Migration[6.0]
  def change
    remove_column :likes, :article_id, :integer
    remove_column :likes, :comment_id, :integer

    add_reference :likes, :likeable, polymorphic: true, index: true
  end
end
