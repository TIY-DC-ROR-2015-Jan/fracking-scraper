Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  resource :profile, only: [:edit, :update] do
    resources :tokens, only: [:create, :destroy]
  end

  scope :api do
    namespace :v1 do
      get 'weather'           => 'weather#my_location'
      get 'weather/:location' => 'weather#location'
    end
  end

  root 'profiles#edit'
end
