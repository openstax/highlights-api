class AddContentPathToHighlights < ActiveRecord::Migration[5.2]
  def change
    add_column :highlights, :content_path, :integer, array: true
  end
end
