class CreateBlackLists < ActiveRecord::Migration[5.0]
  def change
    create_table :black_lists do |t|
      t.string :name, null: false
      t.integer :home_id, defaults: 1, null: false
      t.timestamps
    end
  end
end
