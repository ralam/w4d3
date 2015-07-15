class CatRentalRequestsController < ApplicationController
  before_action :redirect_to_index_if_not_logged_in, except: [:index, :show]
  before_action :make_sure_user_owns_cat, only: [:approve, :deny]

  def approve
    current_cat_rental_request.approve!
    redirect_to cat_url(current_cat)
  end

  def create
    @rental_request = CatRentalRequest.new(cat_rental_request_params)
    @rental_request.user_id = current_user.id
    @requesting_user = User.find(@rental_request.user_id)
    if @rental_request.save
      redirect_to cat_url(@rental_request.cat)
    else
      flash.now[:errors] = @rental_request.errors.full_messages
      render :new
    end
  end

  def deny
    current_cat_rental_request.deny!
    redirect_to cat_url(current_cat)
  end

  def new
    @rental_request = CatRentalRequest.new
  end

  private
  def current_cat_rental_request
    @rental_request ||=
      CatRentalRequest.includes(:cat).find(params[:id])
  end

  def current_cat
    current_cat_rental_request.cat
  end

  def cat_rental_request_params
    params.require(:cat_rental_request)
      .permit(:cat_id, :end_date, :start_date, :status)
  end



  private

  def make_sure_user_owns_cat
    cat_rental = CatRentalRequest.find(params[:id])
    cat = Cat.find(cat_rental.cat_id)

    unless current_user.id == cat.user_id
      flash[:errors] = "Can't approve or deny request for cat you don't own"
      redirect_to cats_url
    end
  end
end
