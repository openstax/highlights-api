class CreateUserAndUserSources < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: :uuid do |t|
      t.integer :num_annotation_characters, default: 0
      t.integer :num_highlights, default: 0
    end

    create_table :user_sources, id: :uuid do |t|
      t.references :user, type: :uuid, index: true, foreign_key: true
      t.string :source_id, null: false
      t.integer :num_highlights, default: 0
    end

    rename_column :highlights, :user_uuid, :user_id
    add_reference :highlights, :users, index: true
  end
end
