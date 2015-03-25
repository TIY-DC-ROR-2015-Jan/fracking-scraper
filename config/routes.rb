Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  resource :profile, only: [:edit, :update] do
    resources :tokens, only: [:create, :destroy]
  end

  root 'profiles#edit'
end
