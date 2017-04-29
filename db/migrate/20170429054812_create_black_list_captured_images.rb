class CreateBlackListCapturedImages < ActiveRecord::Migration[5.0]
  def change
    create_table :black_list_captured_images do |t|
      t.references :black_list, index: true, null: false
      t.references :captured_image, index: true, null: false
    end
  end
end
