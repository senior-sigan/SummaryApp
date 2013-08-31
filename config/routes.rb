CommunityApp::Application.routes.draw do   
  devise_for :owners
  resources :participants, except: [:new, :create] do
    collection do 
      get :activity
      get :top
    end
  end
  resources :events do
    resources :registrations, only: [:index] do
      collection do 
        patch :set_was
        patch :set_categories
        get :categorize 
        get :import
        post :save_import
      end
    end

    collection do
      get :stats
    end
  end
  resources :categories do
    member do
      get :participants
    end
  end
  root  'home#index'
end
