class TagsController < ApplicationController
  before_action :tag_is_exist

  def show
    @notes = @tag.notes.paginate(page: params[:page])
  end
  
  private

    def tag_is_exist
      @tag = Tag.find_by(id: params[:id])
      redirect_to root_url unless @tag
    end
  
end