class ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  before_action :admin_only, only: [:index]
  before_action :authorize_check, only: [:update, :destroy]
  before_filter :authorize, except: [:new, :create]

  def new
    @listing = Listing.new
  end

  def create
    @listing = current_user.listings.new(listing_params)
    if @listing.save
      if params[:images]
        params[:images].each do |image|
          @listing.images.create(image: image)
        end
      end
      redirect_to @listing, notice: "Listing created!"
    else
      redirect_to '/', notice: "Failed to create!"
    end
  end

  def index
    @listings = Listing.all
  end

  def search
    @listings = Listing.search(params[:term], fields: ["state", "city", "address", "name"], misspellings: {below: 5})#.paginate(:page => params[:page]).per_page(20)
    if @listings.blank?
      redirect_to root_path, notice: "No results found!"
    else
      render :search
    end
  end

  def show
  end

  def edit
  end

  def update
    if @listing.update(listing_params)
      if params[:images]
        @listing.images.destroy_all
        params[:images].each do |image|
          @listing.images.create(image: image)
        end
      end
      redirect_to @listing, notice: 'Listing was successfully updated.'
    else
      redirect_to @listing, notice: 'Failed to update listing.'
    end
  end

  def destroy
    @listing.destroy
    redirect_to listings_url, notice: 'Listing was successfully destroyed.'
  end

  def expired_listing
    if @listing.expiration < DateTime.now
      @listing.expired = true
      if !@listing.bids.empty?
        @listing.sold = true
      end
      @listing.save
    end
  end

  private
  def set_listing
    @listing = Listing.find(params[:id])
  end

  def authorize_check
    if @user != current_user && !current_user.admin?
      redirect_to root_path
    end
  end

  def listing_params
      params.require(:listing).permit(:name, :address, :city, :state, :house_type, :num_of_rooms, :price, :expiration, :user_id, images_attributes: [:image, :listing_id])
  end

  def admin_only
    redirect_to sign_in_path unless current_user.admin?
  end
end
