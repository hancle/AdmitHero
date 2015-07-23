class UsersController < ApplicationController
	before_action :logged_in_user, only: [:index, :destroy]
	before_action :admin_user, only: :destroy

	def index
  		@users = User.paginate(page: params[:page])
  	end

  	def new
  		@user = User.new
  	end

  	def show
  		@user = User.find(params[:id])
  	end

  	def create
  	@user = User.new(user_params)
  		if @user.save
  			@user.send_activation_email
  			flash[:info] = "Please check your mailbox to finish the account activation"
  			redirect_to root_url
  		else
  			redirect_to root_url
  		end
  	end

  	def destroy
        User.find(params[:id]).destroy
        flash[:success] = "User deleted"
        redirect_to users_url
	end

  	private

  		def user_params
  			params.require(:user).permit(:name, :email, :password, :password_confirmation)
  		end

  		def logged_in_user
  			unless logged_in?
  				flash[:danger] = "Please login first."
  				redirect_to login_url
  			end
  		end

  		def admin_user
  			redirect_to(root_url) unless current_user.admin?
  		end

end
