class CreateWordRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :word_records do |t|
      t.references :voice_record, null: false, index: true
      t.string :word, null: false
      t.timestamps
    end
  end
end
