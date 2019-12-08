class StaticPagesController < ApplicationController

  def home
    @tag = Tag.find_by(name: params[:tag])
    @all_notes = (@tag) ? @tag.notes : Note.all

    if current_user
      @all_notes = @all_notes.where.not(mode: Note::MODE_LOCAL)
    else
      @all_notes = @all_notes.where(mode: Note::MODE_WEB)
    end

    @page_notes = @all_notes.paginate(page: params[:page])
  end

end
