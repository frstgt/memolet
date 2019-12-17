class MemosController < ApplicationController
  before_action :logged_in_user
  before_action :note_is_exist
  before_action :memo_is_exist,   only: [:edit, :update, :destroy]
  before_action :user_can_edit

  def new
    @pictures = @note.pictures

    @memo = @note.memos.build
    @max = @note.memos.count + 1
    @value = @max
  end

  def create
    @pictures = @note.pictures

    @memo = @note.memos.build(memo_params)
    if @memo.save

      insert_one(@note.memos, @memo)

      flash[:success] = "Memo created"
      redirect_to @note
    else
      render 'new'
    end
  end

  def edit
    @pictures = @note.pictures

    @max = @note.memos.count
    @value = @memo.number
  end

  def update
    @pictures = @note.pictures

    if @memo.update_attributes(memo_params)

      insert_one(@note.memos, @memo)

      flash[:success] = "Memo updated"
      redirect_to @note
    else
      render 'edit'
    end
  end

  def destroy
    @memo.destroy

    delete_one(@note.memos)

    flash[:success] = "Memo deleted"
    redirect_to @note
  end

  private

    def memo_params
      params.require(:memo).permit(:content, :number)
    end

    def note_is_exist
      @note = Note.find(params[:note_id])
      redirect_to root_url unless @note
    end
    def memo_is_exist
      @memo = @note.memos.find(params[:id])
      redirect_to root_url unless @memo
    end

    def user_can_edit
      redirect_to root_url unless @note.can_edit?(current_user)
    end

end
