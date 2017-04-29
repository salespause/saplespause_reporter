class CreateFaceImages < ActiveRecord::Migration[5.0]
  def change
    create_table :face_images do |t|
      t.string :image_url, null: false
      t.string :face_id, null: false
      t.references :black_list, null: false, index: true
      t.timestamps
    end
  end
end
