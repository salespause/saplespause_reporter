class CreateVoiceRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :voice_records do |t|
      t.text :text, null: false
      t.timestamps
    end
  end
end
