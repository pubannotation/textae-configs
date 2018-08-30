Rails.application.routes.draw do
  
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  
  get '/users/:email' => 'users#show', :constraints => { :email => /.+@.+\..*/ }, as: 'user'
  get '/api/login' => 'api#login'
  get '/api/loggedin' => 'api#loggedin'

  resources :configs
  root 'configs#index'
end
