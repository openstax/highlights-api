# OpenStax Highlights
class CreateHighlights < ActiveRecord::Migration[5.2]
  def change
    # https://stackoverflow.com/questions/47064090/rails-postgres-migration-why-am-i-receiving-the-error-pgundefinedfunction
    enable_extension 'uuid-ossp'
    enable_extension 'pgcrypto'

    create_table :highlights, id: :uuid do |t|
      t.uuid :user_uuid, null: false, index: true
      t.integer :source_type, null: false, index: true, default: 0
      t.string :source_id, null: false
      t.jsonb :source_metadata, null: true
      t.text :source_parent_ids, array: true, default: []
      t.text :anchor, null: false
      t.text :highlighted_content, null: false
      t.text :annotation, null: true
      t.string :color, null: false
      t.text :source_order, null: true
      t.integer :order_in_source, null: true
      t.jsonb :location_strategies, null: false

      t.timestamps null: false
    end

    add_index :highlights, :source_parent_ids, using: 'gin'
  end
end



