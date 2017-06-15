Rails.application.routes.draw do


  get 'comment/create'
  get 'feedback/new'
  post 'feedbacks', to: 'feedback#create'

  get 'cource_read_more/index'

  get 'cource_read_more/Cource'

  root to: "home#index"
  resources :home


  resources :user_adits

  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users
  resources :cource_read_more
  resources :cources do
    collection do
      post :publish
      get :viewed
      get :registed
      get :search
      get :ajax
    end
  end

  resources :news , only: [:index, :show] do
    collection do
      get '/category/:id', to: 'news#index', as: 'cate'
    end
  end

  resources :list_cources_posted do
  end

  namespace :admin do
    resources :dashboards do
      collection do
        post :import
      end
    end
    resources :cource_tags
    resources :cources do
      collection do
        post :import
        delete :destroy_multiple
        get '/:id/duplicate', to: 'cources#duplicate', as: 'duplicate'
      end
    end
    resources :feedbacks do
      collection do
        post :import
        get '/:id/duplicate', to: 'feedbacks#duplicate', as: 'duplicate'
        delete :destroy_multiple
      end
    end
    resources :configs do
      collection do
        post :import
        get '/:id/duplicate', to: 'configs#duplicate', as: 'duplicate'
        delete :destroy_multiple
      end
    end
    resources :provinces do
      collection do
        post :import
        get '/:id/duplicate', to: 'provinces#duplicate', as: 'duplicate'
        delete :destroy_multiple
      end
    end
    resources :news do
      collection do
        post :import
        get '/:id/duplicate', to: 'news#duplicate', as: 'duplicate'
        delete :destroy_multiple
      end
    end
    resources :category_news do
      collection do
        post :import
        get '/:id/duplicate', to: 'category_news#duplicate', as: 'duplicate'
        delete :destroy_multiple
      end
    end
    resources :banners do
      collection do
        post :import
        get '/:id/duplicate', to: 'banners#duplicate', as: 'duplicate'
        delete :destroy_multiple
      end
    end
    resources :slides do
      collection do
        post :import
        get '/:id/duplicate', to: 'slides#duplicate', as: 'duplicate'
        delete 'destroy_multiple'
      end
    end
    resources :tags do
      collection do
        post :import
        get '/:id/duplicate', to: 'tags#duplicate', as: 'duplicate'
        delete :destroy_multiple
      end
    end
    resources :categories do
      collection do
        post :import
        post :reorder
        get '/:id/duplicate', to: 'categories#duplicate', as: 'duplicate'
        delete 'destroy_multiple'
      end
    end
    resources :users do
      collection do
        post :import
        delete 'destroy_multiple'
        get '/:id/duplicate', to: 'users#duplicate', as: 'duplicate'
      end
    end
    resources :groups do
      collection do
        post :import
        get '/:id/duplicate', to: 'groups#duplicate', as: 'duplicate'
        delete 'destroy_multiple'
      end
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
