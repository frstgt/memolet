class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(name: params[:session][:name])
    if user && user.authenticate(params[:session][:password])
      log_in user

      if user.admin? && Site.count == 0
        Site.create()
      end

      redirect_back_or user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end  end

  def destroy
    log_out
    redirect_to root_url
  end

end
