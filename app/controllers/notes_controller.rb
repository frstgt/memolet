class NotesController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :note_is_exist,   only: [:show, :edit, :update, :destroy]

  def index
    @notes = Note.paginate(page: params[:page])
  end

  def show
    @note = current_user.notes.find(params[:id])
    @memos = @note.memos.paginate(page: params[:page])
    @pictures = @note.pictures
  end

  def new
    @note = current_user.notes.build
  end

  def create
    @note = current_user.notes.build(note_params)
    if @note.save

      @note.save_tag_list

      flash[:success] = "Note created"
      redirect_to current_user
    else
      render 'new'
    end
  end

  def edit
    @note.load_tag_list
  end

  def update
    if @note.update_attributes(note_params)

      @note.save_tag_list

      flash[:success] = "Note updated"
      redirect_to @note
    else
      render 'edit'
    end
  end

  def destroy
    @note.destroy
    flash[:success] = "Note deleted"
    redirect_to current_user
  end

  private

    def note_params
      params.require(:note).permit(:title, :outline, :tag_list)
    end

    def note_is_exist
      @note = current_user.notes.find(params[:id])
      redirect_to root_url unless @note
    end

end
