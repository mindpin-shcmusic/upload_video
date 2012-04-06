class MediaFilesController < ApplicationController
  before_filter :login_required
  before_filter :pre_load
  def pre_load
    @media_file = MediaFile.find(params[:id]) if params[:id]
  end
  
  def new
    @media_file = MediaFile.new
  end
  
  def create
    @media_file = MediaFile.new(params[:media_file])
    @media_file.creator = current_user
    if @media_file.save
      return redirect_to "/media_files/#{@media_file.id}"
    end
    error = @media_file.errors.first
    flash[:error] = "#{error[0]} #{error[1]}"
    redirect_to "/media_files/new"
  end
  
  def show
  end
  
  def index
  end
  
  def show
end

  def into_the_encode_queue
    @media_file.into_the_encode_queue
    redirect_to "/media_files/#{@media_file.id}"
  end
end
