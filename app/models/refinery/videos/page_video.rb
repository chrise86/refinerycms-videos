module Refinery
  module Videos
    class PageVideo < ActiveRecord::Base

      belongs_to :video, :foreign_key => 'raw_video_id', :class_name => '::Refinery::RawVideo'
      belongs_to :page, :polymorphic => true

      translates :caption if self.respond_to?(:translates)

      attr_accessible :raw_video_id, :position, :locale, :page_id
      self.translation_class.send :attr_accessible, :locale

    end
  end
end
