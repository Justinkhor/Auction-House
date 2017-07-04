class HomeController < ApplicationController
  def index
    @listings = Listing.all.order("created_at DESC").paginate(:page => params[:page]).per_page(20)
  end
end
