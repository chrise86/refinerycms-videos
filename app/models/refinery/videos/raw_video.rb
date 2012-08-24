module Refinery
  module Videos
    class RawVideo < ActiveRecord::Base

      has_many :encoded_videos
      has_many :page_videos, :dependent => :destroy

      belongs_to :poster_image, :class_name => 'Refinery::Image'
      attr_accessible :poster_image_id, :title

      video_accessor :file
      attr_accessible :file

      delegate :name, :uid, :mime_type, :v_height, :v_width, :ext, :frame_rate, :to => :file
      delegate :duration, :bitrate, :size, :stream, :codec, :colorspace, :resolution, :to => :file
      delegate :audio_stream, :audio_codec, :audio_sample_rate, :audio_channels, :to => :file
      delegate :url, :remote_url, :to => :file

      validates :file, :presence => true

      acts_as_indexed :fields => [:name]

      class << self

        # will-paginate default videos per page. To override this setting: 
        #   Refinery::RawVideo.per_page = num
        per_page = 12

        def create_video(params)
          if Refinery::Videos.use_nginx_upload_module
            create_video_from_nginx_upload(params)
          else
            create(params[:raw_video])
          end
        end

        def html5_sort(encoded_videos)
          encoded_videos.sort do |vid_1, vid_2|
            self.format_weight(vid_1.format) <=> self.format_weight(vid_2.format)
          end
        end

        protected
        
        def create_video_from_nginx_upload(params)
          video_path = File.join(File.dirname(params[:nginx_upload][:path]), params[:nginx_upload][:file_name])
          FileUtils.mv(params[:nginx_upload][:path], video_path)
          begin
            params[:raw_video][:file] = Pathname.new(video_path)
            new_video = create(params[:raw_video])
          ensure
            FileUtils.rm(video_path)
          end
        end

      end

      def encode(format, options = {})
        options.symbolize_keys!
        options[:meta] = {} unless options[:meta]

        default_meta = {
          :name => File.basename(self.name, '.*') + ".#{format.to_s}"
        }

        options[:meta] = default_meta.merge(options[:meta])

        EncodedVideo.create! do |encoded_video|
          encoded_video.raw_video = self
          encoded_video.file = self.file.html5(format, options).apply
          encoded_video.format = format.to_s
        end
      end

      def async_encode(*formats)
        formats.each { |format| Resque.enqueue(Refinery::Videos::EncodeVideo, self.id, format) }
      end

      def display_title
        return self.title unless self.title.blank?
        CGI::unescape( self.file_name ).gsub(/\.\w+$/, '').titleize
      end

      def encoded?
        !self.encoded_videos.by_format('mp4').empty? && 
        !self.encoded_videos.by_format('ogv').empty? &&
        !self.encoded_videos.by_format('webm').empty?
      end

      def poster_image_url
        self.poster_image.present? ? self.poster_image.image.url : nil
      end

      private
    
      @@format_weights = {
        'mp4' => 1,
        'webm' => 2,
        'ogv' => 3
      }
      
      class << self
        def format_weight(format)
          weight = @@format_weights[format]
          weight ? weight : 0
        end
      end
    end
  end
end
