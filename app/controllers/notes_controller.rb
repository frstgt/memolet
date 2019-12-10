class NotesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :note_is_exist,  only: [:show, :edit, :update, :destroy]
  before_action :user_can_show,  only: :show
  before_action :user_can_edit,  only: [:edit, :update, :destroy]

  def index
    @tag = Tag.find_by(name: params[:tag])

    if current_user
      @all_notes = tag_notes(@tag).where.not(mode: Note::MODE_LOCAL)
      @all_tags = notes_tags(Note.where.not(mode: Note::MODE_LOCAL))
    else
      @all_notes = tag_notes(@tag).where(mode: Note::MODE_WEB)
      @all_tags = notes_tags(Note.where(mode: Note::MODE_WEB))
    end

    @page_notes = @all_notes.paginate(page: params[:page])
  end

  def show
    @note = Note.find(params[:id])
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
      params.require(:note).permit(:title,
                                    :outline,
                                    :tag_list,
                                    :mode,
                                    :picture)
    end

    def note_is_exist
      @note = Note.find(params[:id])
      redirect_to root_url unless @note
    end

    def user_can_show
      redirect_to root_url unless @note.can_show?(current_user)
    end
    def user_can_edit
      redirect_to root_url unless @note.can_edit?(current_user)
    end

end
