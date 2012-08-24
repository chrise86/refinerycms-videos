module Refinery
  module Videos
    class RawVideosController < ::ApplicationController

      respond_to :html

      def show
        @raw_video = Refinery::Videos::RawVideo.find(params[:id])
        respond_with(@raw_video)
      end
    end
  end
end
