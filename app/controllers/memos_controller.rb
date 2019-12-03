class MemosController < ApplicationController
  before_action :logged_in_user
  before_action :note_is_exist,   only: [:new, :create, :edit, :update, :destroy]
  before_action :memo_is_exist,   only: [:edit, :update, :destroy]

  def new
    @memo = @note.memos.build
    @max = @note.memos.count + 1
    @value = @max
  end

  def create
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
    @max = @note.memos.count
    @value = @memo.number
  end

  def update
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
      @note = current_user.notes.find(params[:note_id])
      redirect_to root_url unless @note
    end
    def memo_is_exist
      @memo = @note.memos.find(params[:id])
      redirect_to root_url unless @memo
    end

end
