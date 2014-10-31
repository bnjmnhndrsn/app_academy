class BandsController < ApplicationController
  
  before_action :require_login
    
  def index
    @bands = Band.all
  end
  
  def new
    @band = Band.new
  end
  
  def create
    @band = Band.new(band_params)
    if @band.save
      redirect_to band_path(@band.id)
    else
      flash.now[:errors] = @band.errors
      render :new
    end 
  end
  
  def edit
    @band = Band.find(params[:id])
    
  end
  
  def update
    @band = Band.find(params[:id])
    @band.update(band_params)
    if @band.save
      redirect_to band_path(@band.id)
    else
      flash.now[:errors] = @band.errors
      render :edit
    end
  end
  
  def show
    @band = Band.find(params[:id])
  end
  
  def destroy
    band = Band.find(params[:id])
    band.destroy
    redirect_to bands_path
  end
  
  def band_params
    params[:band].permit(:name)
  end
end