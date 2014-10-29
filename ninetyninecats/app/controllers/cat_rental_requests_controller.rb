class CatRentalRequestsController < ApplicationController
  def new
    # nested routes


    @cat_rental_request = CatRentalRequest.new
    @cat_rental_request.cat_id = params[:cat_id]
    render :new

  end

  def create
   @cat_rental_request = CatRentalRequest.new(rental_request_params)
    if @cat_rental_request.save
      redirect_to cat_url(@cat_rental_request.cat_id)
    else
      flash.notice = @cat_rental_request.errors.full_messages
      render :new
    end
  end

  def update
    @cat_rental_request = CatRentalRequest.find(params[:id])
    if rental_request_params[:status] == "APPROVE"
      @cat_rental_request.approve!
    elsif rental_request_params[:status] == "DENY"
      @cat_rental_request.deny!
    end

    redirect_to cat_url(@cat_rental_request.cat_id)
  end

  private
  def rental_request_params
    params[:cat_rental_request].permit(:start_date, :end_date, :cat_id, :status)
  end
end