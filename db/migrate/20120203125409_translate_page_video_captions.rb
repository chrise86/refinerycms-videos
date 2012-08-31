class TranslatePageVideoCaptions < ActiveRecord::Migration
  def up
    add_column Refinery::Videos::PageVideo.table_name, :id, :primary_key

    Refinery::Videos::PageVideo.reset_column_information
    unless defined?(Refinery::Videos::PageVideo::Translation) && Refinery::Videos::PageVideo::Translation.table_exists?
      Refinery::Videos::PageVideo.create_translation_table!({
        :caption => :text
      }, {
        :migrate_data => true
      })
    end
  end

  def down
    Refinery::Videos::PageVideo.reset_column_information

    Refinery::Videos::PageVideo.drop_translation_table! :migrate_data => true

    remove_column Refinery::Videos::PageVideo.table_name, :id
  end
end
