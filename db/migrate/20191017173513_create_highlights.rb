# OpenStax Highlights
class CreateHighlights < ActiveRecord::Migration[5.2]
  def change
    create_table :highlights do |t|
      t.uuid :user_uuid, null: false, index: true
      t.integer :source_type, null: false, default: 0
      t.uuid :source_uuid, null: false
      t.jsonb :source_metadata, null: true
      t.text :source_parent_ids, array: true, default: []
      t.text :anchor, null: false
      t.text :highlighted_content, null: false
      t.text :annotation, null: true
      t.string :color, null: false
      t.text :source_pagingation_order, null: true
      t.integer :order_in_source, null: true
      t.jsonb :location_strategies, null: false

      t.timestamps null: false
    end
  end
end



