class SitesController < ApplicationController
  before_action :logged_in_user
  before_action :site_is_exist
  before_action :user_can_edit

  def edit
  end
  def update
    if @site.update_attributes(site_params)
      flash[:success] = "Site updated"
      redirect_to root_url
    else
      render 'edit'
    end
  end

  private

    def site_params
      params.require(:site).permit(:name, :mode)
    end

    def site_is_exist
      @site = Site.first
      redirect_to root_url unless @site
    end

    def user_can_edit
      redirect_to root_url unless @site.can_edit?(current_user)
    end

end
