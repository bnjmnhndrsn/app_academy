class CatsController < ApplicationController
  def index
    @cats = Cat.all
  end

  def show
    @cat = Cat.find(params[:id])
  end

  def new
    @cat = Cat.new
  end

  def create
    @cat = Cat.new(cat_params)
    if @cat.save
      redirect_to cat_url(@cat.id)
    else
      flash.now[:notice] = @cat.errors.full_messages
      render :new
    end
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update(cat_params)
      render :show
    else
      flash.notice = @cat.errors.full_messages
      # render instead of redirect
      redirect_to edit_cat_url(@cat.id)
    end
  end

  def edit
    @cat = Cat.find(params[:id])
  end

  private
  def cat_params
    params[:cat].permit(:name, :sex, :color, :birth_date, :description)
  end
end