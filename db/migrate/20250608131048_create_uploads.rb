class CreateUploads < ActiveRecord::Migration[7.2]
  def change
    create_table :uploads do |t|
      t.string :upload_id
      t.timestamps
    end

    add_index :uploads, :upload_id, unique: true
  end
end
