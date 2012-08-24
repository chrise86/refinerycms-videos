Refinery::Core::Engine.routes.draw do
  namespace :videos do
    root :to => "pages#show", :id => "videos"
    resources :raw_videos, :only => [:show]
  end
  
  namespace :videos, :path => '' do
    namespace :admin, :path => "refinery" do
      scope :path => 'videos' do
        root :to => "raw_videos#index"
        
        resources :raw_videos, :path => 'videos', :except => :show do
          collection do
            get :insert
            get :embed
            post :upload
            post :update_positions
          end
        end
      end
    end
  end
end
