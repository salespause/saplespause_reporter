class CreateCapturedImages < ActiveRecord::Migration[5.0]
  def change
    create_table :captured_images do |t|
      t.string :content
      t.integer :face_id
      t.timestamps
    end
  end
end
