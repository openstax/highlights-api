class ReworkHighightOrdering < ActiveRecord::Migration[5.2]
  def change
    remove_column :highlights, :order_in_source
    add_column :highlights, :order_in_source, :float, null: false, index: true

    # We are no longer tracking order of sources in larger contexts
    remove_column :highlights, :source_order

    add_reference :highlights, :prev_highlight, type: :uuid, null: true, index: true
    add_reference :highlights, :next_highlight, type: :uuid, null: true, index: true

    add_foreign_key :highlights, :highlights, column: :prev_highlight_id, primary_key: :id
    add_foreign_key :highlights, :highlights, column: :next_highlight_id, primary_key: :id
  end
end
