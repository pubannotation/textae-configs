Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }

	get '/users/:email' => 'users#show', :constraints => { :email => /.+@.+\..*/ }, as: 'user'

  resources :configs
  root 'configs#index'
end
