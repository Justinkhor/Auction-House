class BidsController < ApplicationController
  before_action :require_login, only: [:show, :edit, :update, :destroy]


	def index
    @bids = Bid.all.order('created_at DESC')#.paginate(:page => params[:page]).per_page(20)
	end

	def show

	end

  def edit

  end

  def create
    @listing = Listing.find(params[:listing_id])
		@bid = current_user.bids.new(bid_params)
    @bid.listing = @listing

      if params[:bid][:bidding_price].to_i < @listing.price
        redirect_to listing_path(@listing), notice: "Minimum bid is RM#{@listing.price}."
      elsif params[:bid][:bidding_price].to_i < highest_bid
        redirect_to listing_path(@listing), notice: "Please make a higher bid."
      else
        expired_bid
         @bid.save
         respond_to do |format|
           format.html {redirect_to listing_path(@listing), notice: "Congratulations on being the highest bidder at the moment!"}
           format.js{}
         end
      end
	end

  def update
  end

  def destroy
    @bid = Bid.find(params[:id])
    @bid.destroy
    redirect_to @bid.user
  end

  def highest_bid
    if !@listing.bids.empty?
      bid = @listing.bids.order('bidding_price DESC').first.bidding_price
    else
      bid = @listing.price
    end
  end

  def expired_bid
    bid = @listing.bids.order('bidding_price DESC').first
      if bid != nil
        bid.chosen_bid = false
        bid.save
        # BidMailer.bid_email(current_user, @host, @bid.listing.id, @bid.id).deliver_later
        #BidJob.perform_later(bid.user_id, @listing.id)
      end
  end

  def winner
    if @listing.expiration < DateTime.now
      bid = @listing.bids.find_by(chosen_bid: true)
      WinningbidJob.perform_later(bid.user_id, bid.id)
    end
  end

  private
		def bid_params
			params.require(:bid).permit(:bidding_price, :chosen_bid, :payment_made, :listing_id, :user_id)
		end
end
