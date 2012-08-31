class ChangePageVideoToPolymorphic < ActiveRecord::Migration
  def change
    add_column Refinery::Videos::PageVideo.table_name, :page_type, :string, :default => "page"
  end
end
