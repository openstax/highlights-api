class CreateInfoData < ActiveRecord::Migration[5.2]
  def change
    create_table :info_data do |t|
      t.json 'data'
    end
  end
end
