class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :admin_only, only: [:index]
  before_action :authorize_check, only: [:update, :destroy]
  before_filter :authorize, except: [:new, :create]

  def new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to '/'
    else
      redirect_to '/signup', notice: "Failed to sign up!"
    end
  end

  def index
    @users = User.all
  end

  def show
    @bids = current_user.bids.all
    listing_ids = current_user.bids.where(chosen_bid: true).pluck(:listing_id)
    @listings = Listing.where(id: listing_ids)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'User was successfully updated.'
    else
      redirect_to @user, notice: 'Failed to update.'
    end
  end

  def destroy
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def authorize_check
    if @user != current_user && !current_user.admin?
      redirect_to root_path
    end
  end

  def user_params
      params.require(:user).permit(:first_name, :last_name, :username, :email, :password, :avatar)
  end

  def admin_only
    redirect_to root_path unless current_user.admin?
  end
end
