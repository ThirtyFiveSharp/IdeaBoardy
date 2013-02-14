def config_api_routes
  namespace :api do
    resources :boards do
      resources :sections, only: [:index, :create], controller: :board_sections
      resources :concepts, only: [:index, :create], controller: :board_concepts
      resources :tags, only: [:index, :create], controller: :board_tags
      resources :tagcloud, only: [:index], controller: :tag_cloud
    end

    resources :sections, except: [:index, :create] do
      member do
        post :immigration
      end
      resources :ideas, only: [:index, :create], controller: :section_ideas
    end

    resources :ideas, except: [:index, :create] do
      member do
        post :vote
        post :merging
        put :tags
      end
      resources :tags, only: :index, controller: :idea_tags
    end

    resources :tags, except: [:index, :create]

    resources :concepts, except: :create do
      member do
        put :tags
      end
      resources :tags, only: :index, controller: :concept_tags
    end

    post 'emails/invitation'
    post 'emails/share'
  end
end

def config_shorten_url_routes
  get 'url/:shortenUrlCode' => 'shortenUrl#get'
end

def config_admin_site_routes
  devise_for :users, :controllers => {:sessions => "admin/sessions"}
  namespace :admin do
    resource :settings
    match 'boards' => 'boards#export'
    get 'boards/import'
    get 'boards/download'
    post 'boards/upload'
  end
  match 'admin' => 'admin/settings#show'
end

def config_web_site_routes
  root :to => 'home#index'
  match 'm' => 'mobile#index'
  match '/:mobile' => 'mobile#index', :constraints => {:mobile => /m.*/}
  match '*everything_else' => 'home#index'
end

IdeaBoardy::Application.routes.draw do
  config_api_routes
  config_shorten_url_routes
  config_admin_site_routes
  config_web_site_routes
end
