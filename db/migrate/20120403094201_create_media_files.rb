class CreateMediaFiles < ActiveRecord::Migration
  def change
    create_table :media_files do |t|
      t.string    :file_file_name
      t.string    :file_content_type
      t.integer   :file_file_size
      t.datetime  :file_updated_at
      t.string    :uuid
      t.string    :place
      t.text      :desc
      t.integer   :creator_id
      t.timestamps
    end
  end
end
