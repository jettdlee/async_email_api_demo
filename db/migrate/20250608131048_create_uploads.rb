class CreateUploads < ActiveRecord::Migration[7.2]
  def change
    create_table :uploads do |t|
      t.string :upload_id
      t.integer :total_records, default: 0
      t.integer :processed_records, default: 0
      t.integer :failed_records, default: 0
      t.json :details, default: []

      t.timestamps
    end

    add_index :uploads, :upload_id, unique: true
  end
end
