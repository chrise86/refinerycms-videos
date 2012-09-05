# This migration comes from refinery_videos
class RenameTablesForRefinery2 < ActiveRecord::Migration
  def up
    rename_table :refinery_raw_videos, :refinery_videos_raw_videos
    rename_table :refinery_encoded_videos, :refinery_videos_encoded_videos
    rename_table :refinery_page_videos, :refinery_videos_page_videos
    rename_table :refinery_page_video_translations, :refinery_videos_page_video_translations
    
    rename_column :refinery_videos_page_video_translations, :refinery_page_video_id, :refinery_videos_page_video_id
  end
  
  def down
    rename_table :refinery_videos_raw_videos, :refinery_raw_videos
    rename_table :refinery_videos_encoded_videos, :refinery_encoded_videos
    rename_table :refinery_videos_page_videos, :refinery_page_videos
    rename_table :refinery_videos_page_video_translations, :refinery_page_video_translations
    
    rename_column :refinery_videos_page_video_translations, :refinery_videos_page_video_id, :refinery_page_video_id
  end
end
