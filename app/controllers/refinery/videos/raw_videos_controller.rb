module Refinery
  module Videos
    class RawVideosController < ::ApplicationController

      respond_to :html

      def index
        puts "SENT REQUEST TO WRONG PLACE"
        redirect_to :controller => "/refinery/videos/admin/raw_videos", :action => "index"
      end

      def show
        @raw_video = Refinery::Videos::RawVideo.find(params[:id])
        respond_with(@raw_video)
      end
    end
  end
end
