class ChangeColumnNullLikes < ActiveRecord::Migration[6.0]
  def change
    change_column_null :likes, :article_id, true, nil
    change_column_null :likes, :comment_id, true, nil
  end
end
