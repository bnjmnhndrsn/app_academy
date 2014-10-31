class TracksController < ApplicationController
  
  before_action :require_login
  
  def new
    @track = Track.new(album_id: params[:album_id])
  end
  
  def create
    @track = Track.new(track_params)
    if @track.save
      redirect_to track_path(@track.id)
    else
      flash.now[:errors] = @track.errors
      render :new
    end
  end
  
  def show
    @track = Track.find(params[:id])
  end
  
  def edit
    @track = Track.find(params[:id])
  end
  
  def update
    @track = Track.find(params[:id])
    if @track.update(track_params)
      redirect_to track_path(@track.id)
    else
      flash.now[:errors] = @track.errors
      render :edit
    end
  end
  
  def track_params
    params[:track].permit(:album_id, :track_type, :name, :lyrics)
  end
  
  def destroy
    track = Track.find(params[:id])
    album_id = track.album_id
    track.try(:destroy)
    redirect_to album_path(album_id)
  end
  
end