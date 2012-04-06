class AddVideoEncodeStatusColumnToMediaFiles < ActiveRecord::Migration
  def change
    add_column :media_files, :video_encode_status, :string
  end
end
