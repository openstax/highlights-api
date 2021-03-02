class CreatePrecalculateds < ActiveRecord::Migration[5.2]
  def change
    create_table :precalculateds do |t|
      t.string :data_type, default: 'info'
      t.json 'data'
    end
  end
end
