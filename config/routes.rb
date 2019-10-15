Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', as: :destroy_user_session
  end
  resource :user, only: [:edit, :update], controller: 'users'
  resources :blogs do
    resources :entries, only: [:new, :create, :show, :edit, :update, :destroy] do
      resources :comments, only: [:create, :destroy] do
        member do
          put 'approve'
        end
      end
    end
  end
  root to: 'blogs#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
