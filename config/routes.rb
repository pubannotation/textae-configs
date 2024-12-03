Rails.application.routes.draw do
	devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }

	get '/users/:email' => 'users#show', :constraints => { :email => /.+@.+\..*/ }, as: 'user'
	post '/configs/:id', to: 'configs#update'

	resources :configs
	root 'configs#index'

	namespace :api do
		namespace :v1 do
			resources :configs, only: :create
		end
	end
end
