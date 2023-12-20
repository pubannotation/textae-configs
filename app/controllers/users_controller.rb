class UsersController < ApplicationController
	before_action :is_root_user?, only: :index
	
	def index
		@users = User.all.page(params[:page]) 
	end

	def show
		@user = User.friendly.find(params[:email])
		@configs_grid = initialize_grid(Config, conditions:{user_id: @user.id})
	end
end
