Refinery::Core::Engine.routes.draw do
  namespace :videos do
    root :to => "pages#show", :id => "videos"
    resources :raw_videos, :only => [:show]
  end
  
  
  namespace :videos, :path => "refinery" do
    namespace :admin, :path => "videos" do
      root :to => "raw_videos#index"
        
      resources :raw_videos, :path => '', :except => :show do
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
