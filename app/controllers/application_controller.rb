class ApplicationController < ActionController::Base
  protect_from_forgery



  before_filter :authorize, :except => [:create, :new, :signup, :login, :index, :show ]

  protected
  def authorize
    unless User.find_by_id(session[:user_id])
      #puts request.url
      session[:original_uri] = request.url
      flash[:notice] = "Please log in"
      redirect_to :controller => 'admin', :action => 'login'
    end
  end
end
