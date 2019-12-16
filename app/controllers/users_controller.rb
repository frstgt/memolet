class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :user_is_exist,  only: [:show, :edit, :update, :destroy]
  before_action :user_can_show,  only: :show
  before_action :user_can_new,   only: [:new, :create]
  before_action :user_can_edit,  only: [:edit, :update, :destroy]
  before_action :user_cannot_delete_admin, only: :destroy

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

    if current_user
      if current_user?(@user)
        @all_notes = search_notes_with_tags(@user.notes, [@tag])
        @all_tags = get_tags_from_notes(@user.notes)
        @author = @description = @keywords = ""
      else
        no_local_notes = @user.notes.where.not(mode: Note::MODE_LOCAL)
        @all_notes = search_notes_with_tags(no_local_notes, [@tag])
        @all_tags = get_tags_from_notes(no_local_notes)
        @author = @description = @keywords = ""
      end
    else
      web_notes = @user.notes.where(mode: Note::MODE_WEB)
      @all_notes = search_notes_with_tags(web_notes, [@tag])
      @all_tags = get_tags_from_notes(web_notes)
      @author = @user.name
      @description = @user.outline
      @keywords = make_tag_list(@all_tags)
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
      flash[:success] = "User updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name,
                                    :password,
                                    :password_confirmation,
                                    :outline,
                                    :mode,
                                    :admin_en,
                                    :picture)
    end

    def user_is_exist
      @user = User.find(params[:id])
      redirect_to root_url unless @user
    end

    def user_can_show
      redirect_to root_url unless @user.can_show?(current_user)
    end
    def user_can_new
      redirect_to root_url unless User.can_new?(current_user)
    end
    def user_can_edit
      redirect_to root_url unless @user.can_edit?(current_user)
    end

    def user_cannot_delete_admin
      redirect_to root_url if @user.admin?
    end

end
