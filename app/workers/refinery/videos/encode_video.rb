module Refinery
  module Videos
    class EncodeVideo
      @queue = Refinery::Videos.encode_queue_name

      def self.perform(video_id, format, options = {})
        @raw_video = Refinery::Videos::RawVideo.find(video_id)
        @raw_video.encode(format, options)
      end

    end
  end
end
