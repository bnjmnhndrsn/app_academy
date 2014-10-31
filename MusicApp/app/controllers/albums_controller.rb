class AlbumsController < ApplicationController
  
  before_action :require_login
  
  def new
    @album = Album.new(band_id: params[:band_id])
  end
  
  def create
    @album = Album.new(album_params)
    if @album.save
      redirect_to album_path(@album.id)
    else
      flash.now[:errors] = @album.errors
      render :new
    end
  end
  
  def show
    @album = Album.find(params[:id])
  end
  
  def edit
    @album = Album.find(params[:id])
  end
  
  def update
    @album = Album.find(params[:id])
    if @album.update(album_params)
      redirect_to album_path(@album.id)
    else
      flash.now[:errors] = @album.errors
      render :edit
    end
  end
  
  def album_params
    params[:album].permit(:band_id, :album_type, :name)
  end
  
  def destroy
    album = Album.find(params[:id])
    band_id = album.band_id
    album.try(:destroy)
    redirect_to band_path(band_id)
  end
  
end