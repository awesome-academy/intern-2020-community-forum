Rails.application.routes.draw do
  mount Ckeditor::Engine => "/ckeditor"

  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "static_pages/home"
    get "static_pages/help", as: "help"
    get "static_pages/about", as: "about"
    get "static_pages/contact", as: "contact"

    get "trends/index", as: "trends"

    namespace :admin do
      root "dashboard#index"

      get "/signup", to: "registers#index"
      get "/login", to: "sessions#new"
      post "/login", to: "sessions#create"
      delete "/logout", to: "sessions#destroy"
      patch "users/activate/:id", to: "block#update", as: "user_activate"
      patch "topics/activate/:id", to: "topics#activate", as: "topic_activate"
      patch "users/authorize/:id", to: "block#authorize", as: "user_authorize"
      get "posts/chart", to: "charts#post_new", as: "chart_post"
      get "users/chart", to: "charts#user_new", as: "chart_user"
      resources :users
      resources :posts
      resources :topics
    end

    resources :users, except: %i(new create destroy) do
      resources :favorites, only: :index
    end
    resources :posts
    resources :topics, only: %i(index show)
    resources :post_marks, :post_likes, only: %i(create destroy)
  end
end
