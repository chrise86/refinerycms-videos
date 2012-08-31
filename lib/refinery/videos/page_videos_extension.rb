module Refinery
  module Videos
    module Extension
      def has_many_page_videos
        has_many :page_videos, :as => :page, :order => 'position ASC', :class_name => "::Refinery::Videos::PageVideo"
        has_many :videos, :through => :page_videos, :order => 'position ASC', :class_name => "::Refinery::Videos::PageVideo"

        # accepts_nested_attributes_for MUST come before def videos_attributes=
        # this is because videos_attributes= overrides accepts_nested_attributes_for.

        accepts_nested_attributes_for :videos, :allow_destroy => false

        # need to do it this way because of the way accepts_nested_attributes_for
        # deletes an already defined videos_attributes
        module_eval do
          def videos_attributes=(data)
            ids_to_keep = data.map{|i, d| d['page_video_id']}.compact

            page_videos_to_delete = if ids_to_keep.empty?
              self.page_videos
            else
              self.page_videos.where(
                Refinery::Videos::PageVideo.arel_table[:id].not_in(ids_to_keep)
              )
            end

            page_videos_to_delete.destroy_all

            data.each do |i, video_data|
              page_video_id, video_id, caption =
                video_data.values_at('page_video_id', 'id', 'caption')

              next if video_id.blank?

              page_video = if page_video_id.present?
                self.page_videos.find(page_video_id)
              else
                self.page_videos.build(:raw_video_id => video_id)
              end

              page_video.position = i
              page_video.caption = caption if Refinery::Videos.captions
              page_video.save
            end
          end
        end

        include Refinery::Videos::Extension::InstanceMethods

        attr_accessible :videos_attributes
      end

      module InstanceMethods

        def caption_for_video_index(index)
          self.page_videos[index].try(:caption).presence || ""
        end

        def page_video_id_for_video_index(index)
          self.page_videos[index].try(:id)
        end
      end
    end
  end
end

ActiveRecord::Base.send(:extend, Refinery::Videos::Extension)
