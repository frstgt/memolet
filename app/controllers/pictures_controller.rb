class PicturesController < ApplicationController
  before_action :logged_in_user
  before_action :note_is_exist
  before_action :picture_is_exist,  only: [:edit, :update, :destroy]
  before_action :user_can_edit

  def new
    @picture = @note.pictures.build
  end
  def create
    @picture = @note.pictures.build(picture_params)
    if @picture.save
      flash[:success] = "Picture created"
      redirect_to @note
    else
      render 'new'
    end
  end

  def edit
    @picture = @note.pictures.find(params[:id])
  end
  def update
    @picture = @note.pictures.find(params[:id])
    if @picture.update_attributes(picture_params)
      flash[:success] = "Picture updated"
      redirect_to @note
    else
      render 'edit'
    end
  end

  def destroy
    @note.pictures.find(params[:id]).destroy
    flash[:success] = "Picture deleted"

    redirect_to @note
  end

  private

    def picture_params
      params.require(:picture).permit(:picture, :title, :outline)
    end

    def note_is_exist
      @note = Note.find_by(id: params[:note_id])
      redirect_to root_url unless @note
    end
    def picture_is_exist
      @picture = @note.pictures.find_by(id: params[:id])
      redirect_to root_url unless @picture
    end

    def user_can_edit
      redirect_to root_url unless @note.can_edit?(current_user)
    end

end
