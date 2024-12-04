Rails.application.routes.draw do
	devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
	resources :access_tokens, only: %i[create destroy]

	get '/users/:email' => 'users#show', :constraints => { :email => /.+@.+\..*/ }, as: 'user'
	post '/configs/:id', to: 'configs#update'

	resources :configs
	root 'configs#index'

	namespace :api do
		namespace :v1 do
			resources :configs, param: :name, only: %i[show update destroy] do
				post '/', to: 'configs#create', on: :member
			end
		end
	end
end
