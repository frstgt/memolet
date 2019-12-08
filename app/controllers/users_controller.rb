class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :user_is_exist,  only: [:show, :edit, :update, :destroy]
  before_action :user_can_show,  only: :show
  before_action :user_can_edit,  only: [:edit, :update, :destroy]

  def index
    if current_user
      @all_users = User.where.not(mode: User::MODE_LOCAL)
    else
      @all_users = User.where(mode: User::MODE_WEB)
    end
    @page_users = @all_users.paginate(page: params[:page])
  end

  def show
    @tag = Tag.find_by(name: params[:tag])
    @all_notes = (@tag) ? @tag.user_notes(@user) : @user.notes

    if current_user
      if !current_user?(@user)
        @all_notes = @all_notes.where.not(mode: Note::MODE_LOCAL)
      end
    else
      @all_notes = @all_notes.where(mode: Note::MODE_WEB)
    end

    @page_notes = @all_notes.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to Memolet!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name,
                                    :password,
                                    :password_confirmation,
                                    :mode)
    end

    def user_is_exist
      @user = User.find(params[:id])
      redirect_to root_url unless @user
    end

    def user_can_show
      redirect_to root_url unless @user.can_show?(current_user)
    end
    def user_can_edit
      redirect_to root_url unless @user.can_edit?(current_user)
    end

end
