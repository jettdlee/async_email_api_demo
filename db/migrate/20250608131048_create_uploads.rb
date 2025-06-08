class CreateUploads < ActiveRecord::Migration[7.2]
  def change
    create_table :uploads do |t|
      t.string :upload_id
      t.integer :total_records
      t.integer :processed_records
      t.integer :failed_records
      t.json :details

      t.timestamps
    end
  end
end
