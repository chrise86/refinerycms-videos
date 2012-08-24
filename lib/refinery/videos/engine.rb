require 'refinerycms-videos'
require 'rails'

module Refinery
  module Videos
    class Engine < Rails::Engine
      include Refinery::Engine

      isolate_namespace Refinery
      engine_name :refinery_videos

      initializer 'videos-with-dragonfly', :before => :load_config_initializers do |app|
        app_videos = Dragonfly[:videos]
        app_videos.configure_with(:rails) do |c|
          c.datastore.root_path = Rails.root.join('public', 'system', 'videos').to_s
          c.url_format = '/system/videos/:job/:basename.:format'
          c.secret = Refinery::Setting.find_or_set(:dragonfly_secret, Array.new(24) { rand(256) }.pack('C*').unpack('H*').first)
        end

        app_videos.define_macro(ActiveRecord::Base, :video_accessor)
        app_videos.analyser.register(Dragonfly::Analysis::FileCommandAnalyser)
        app_videos.configure_with(:ffmpeg)
        app_videos.register_mime_type(:mp4, 'video/mp4')
        app_videos.register_mime_type(:ogv, 'video/ogg')
        app_videos.register_mime_type(:webm, 'video/webm')

        app.config.middleware.insert 0, 'Dragonfly::Middleware', :videos
      end

      initializer "resque" do |app|
        require 'resque'
        require 'resque/server'
        resque_yml = Rails.root.join('config', 'resque.yml')

        resque_config = if (Rails.env.development? || Rails.env.test?) && !resque_yml.exist?
          {}
        else
          YAML.load_file(resque_yml.to_s)
        end

        Resque.redis = resque_config[Rails.env]
      end

      initializer "refinery.assets.precompile" do |app|
         app.config.assets.precompile += [
           "jquery.uploadProgress.js",
           "refinery/videos/*"
        ]
      end
      
      initializer 'refinerycms_videos.helper' do |app|
        ActionView::Base.send :include, RawVideosHelper
      end

      initializer "register refinerycms_videos" do
        Refinery::Plugin.register do |plugin|
          plugin.name = "refinerycms_videos"
          plugin.url = proc { Refinery::Core::Engine.routes.url_helpers.videos_admin_root_path }
          plugin.menu_match = /^\/?(admin|refinery)\/videos/
          plugin.activity = {
            :class_name => :'refinery/raw_video',
            :title => 'name'
          }
        end

        ::Refinery::Pages::Tab.register do |tab|
          tab.name = "videos"
          tab.partial = "/refinery/admin/pages/tabs/videos"
        end

        if defined?(::Refinery::Blog::Tab)
          ::Refinery::Blog::Tab.register do |tab|
            tab.name = "videos"
            tab.partial = "/refinery/admin/pages/tabs/videos"
          end
        end
      end

      config.after_initialize do
        Refinery.register_engine(Refinery::Videos)
      end

      config.to_prepare do
        require 'refinerycms-pages'
        ::Refinery::Page.send :has_many_page_videos
        ::Refinery::Blog::Post.send :has_many_page_videos if defined?(::Refinery::Blog)
      end

    end
  end
end
