class AddScopeIdToHighlights < ActiveRecord::Migration[5.2]
  def change
    add_column :highlights, :scope_id, :string
    add_index :highlights, :scope_id
  end
end
