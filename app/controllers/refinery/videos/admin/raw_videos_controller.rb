module Refinery
  module Videos
    module Admin
      class RawVideosController < Refinery::AdminController

        respond_to :html

        crudify :'refinery/raw_video',
                :title_attribute => 'title',
                :searchable => true,
                :sortable => false

        before_filter :init_dialog

        def create
          @raw_video = Refinery::Videos::RawVideo.create_video(params)

          unless @raw_video.poster_image.present?
            @raw_video.poster_image = default_poster_image
            @raw_video.save!
          end

          if @raw_video
            @raw_video.async_encode(:mp4, :ogv, :webm)
            flash[:notice] = t('encoding', :scope => 'refinery.admin.raw_videos', :title => @raw_video.title)
          end

          respond_with [:refinery_admin, @raw_video], :location => main_app.refinery_admin_raw_videos_path
        end
        alias_method :upload, :create

        # This renders the image insert dialog
        def insert
          self.new if @raw_video.nil?

          @url_override = main_app.refinery_admin_raw_videos_path(request.query_parameters.merge(:insert => true))

          if params[:conditions].present?
            extra_condition = params[:conditions].split(',')

            extra_condition[1] = true if extra_condition[1] == "true"
            extra_condition[1] = false if extra_condition[1] == "false"
            extra_condition[1] = nil if extra_condition[1] == "nil"
          end

          find_all_raw_videos(({extra_condition[0].to_sym => extra_condition[1]} if extra_condition.present?))
          search_all_raw_videos if searching?

          paginate_raw_videos

          #render :action => 'insert'
        end
        
        def embed
          insert
          respond_to do |format|
            puts format.inspect
            format.html {render :layout => false}
            format.js {render :layout => false}
          end
        end

        def paginate_raw_videos
          @raw_videos = @raw_videos.paginate(:page => params[:page])
        end

        def init_dialog
          @app_dialog = params[:app_dialog].present?
          @field = params[:field]
          @update_image = params[:update_image]
          @thumbnail = params[:thumbnail]
          @callback = params[:callback]
          @conditions = params[:conditions]
        end

        def default_poster_image
          Refinery::Image.find_or_create_by_image_name(
            :image_name => Refinery::Videos.default_poster_image.basename.to_s,
            :image => Refinery::Videos.default_poster_image )
        end

      end
    end
  end
end
