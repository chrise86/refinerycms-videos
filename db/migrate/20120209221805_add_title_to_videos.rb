class AddTitleToVideos < ActiveRecord::Migration
  def change
    add_column Refinery::Videos::RawVideo.table_name, :title, :string
  end
end
