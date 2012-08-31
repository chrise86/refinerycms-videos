class CreatePageVideos < ActiveRecord::Migration
  def change
    create_table Refinery::Videos::PageVideo.table_name, :id => false do |t|
      t.integer :raw_video_id
      t.integer :page_id
      t.integer :position
    end

    add_index Refinery::Videos::PageVideo.table_name, :raw_video_id
    add_index Refinery::Videos::PageVideo.table_name, :page_id
  end
end
