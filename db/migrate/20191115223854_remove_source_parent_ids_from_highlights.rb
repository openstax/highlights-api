class RemoveSourceParentIdsFromHighlights < ActiveRecord::Migration[5.2]
  def change
    remove_index :highlights, :source_parent_ids
    remove_column :highlights, :source_parent_ids, :text
  end
end
