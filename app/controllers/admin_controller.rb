class AdminController < ApplicationController
  def login
    #if request.get?
      @user = User.new
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:user_id] = user.id
        uri = session[:original_uri]

        redirect_to ( uri || { :controller => 'posts', :action => 'index' } )
      else
        #flash.now[:notice] = "Invalid user/password combination"
      end

    #end

  end

  def logout
    session[:user_id] = nil
    session[:original_uri] = nil
    flash[:notice] = "Logged out"
    redirect_to :controller => 'admin', :action => 'login'
  end


  def index
    @users = User.all

  end
  protected
  def signup
    @user = User.new

    if @user.save
      redirect_to posts_url
    else
      redirect_to :controller => 'admin', :action => :login
    end
  end
end
