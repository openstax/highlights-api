class AddUserIdSourceIdIndexToHighlights < ActiveRecord::Migration[5.2]
  def change
    add_index :highlights, [:user_id, :source_id]
  end
end
