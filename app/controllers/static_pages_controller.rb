class StaticPagesController < ApplicationController

  def home
    redirect_to notes_path
  end

end
