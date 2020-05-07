class CuratorScope < ActiveRecord::Migration[5.2]
  def change
    create_table :curator_scopes, id: :uuid do |t|
      t.uuid :curator_id, null: false, index: true
      t.uuid :scope_id, null: false
      t.index :scope_id, unique: true
    end
  end
end
