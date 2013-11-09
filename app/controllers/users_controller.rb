class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
    #@users = User.all
    @users = User.all.sort_by { |h| h[:name] }
    if session[:user_id].nil?
      redirect_to posts_url
    else
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @users }
      end
    end


  end

  # GET /users/1
  # GET /users/1.json
  def show
    if session[:user_id].nil?
      redirect_to posts_url
    else
      @user = User.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @user }
      end
    end

  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new
    if session[:usre_id].nil? || User.find_by_id(session[:user_id]).isadmin
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @user }
      end
    else
      redirect_to users_url
    end


  end

  # GET /users/1/edit
  def edit

    @user = User.find(params[:id])

  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    @user.issuperadmin = false
    if session[:user_id].nil?
      @user.isadmin = false
    end

    respond_to do |format|
      if @user.save
        #flash[:notice] = "User #{@user.name} was successfully created" # added
        #format.html { redirect_to(:action=>'index') } # added
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])



    # check whether allow the user edit others' profile
    # allowed_edit = 1 => user can update the profile
    # allowed_edit = 0 => user cannot update the profile

    allowed_edit = 0
    if session[:user_id] == @user.id
      allowed_edit = 1
    end
    if User.find_by_id(session[:user_id]).isadmin && !@user.isadmin && allowed_edit == 0

      allowed_edit = 1
    end
    if User.find_by_id(session[:user_id]).issuperadmin && allowed_edit == 0
      allowed_edit = 1
    end

    if allowed_edit == 1
      respond_to do |format|
        if @user.update_attributes(params[:user])
          #flash[:notice] = "User #{@user.name} was successfully updated" # added
          #format.html { redirect_to(:action=>'index') } # added
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to users_url, notice: 'action not allowed'
    end
    allowed_edit = 0

  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    # already_destroy = 0 => have not been destroyed yet
    # already_destroy = 1 => have been destroyed
    already_destroy = 0
    puts already_destroy
    current_user = User.find_by_id(session[:user_id])
    @user = User.find(params[:id])

    # superadmin will never be destroy
    if @user.issuperadmin
      already_destroy = 1
    end

    # if the current user is superadmin
    if already_destroy ==0 && current_user.issuperadmin
      @user.destroy_related_Post_Reply_Vote(@user.id)
      @user.destroy
      already_destroy = 1
    end

    # admin will destroy user
    if already_destroy == 0 && current_user.isadmin && !@user.isadmin
      @user.destroy_related_Post_Reply_Vote(@user.id)
      @user.destroy
      already_destroy = 1
    end

    # admin destroy himself/herself
    if already_destroy == 0 && current_user.id == @user.id && current_user.isadmin && @user.isadmin
      @user.destroy_related_Post_Reply_Vote(@user.id)
      @user.destroy
      reset_session
      # since the user has been destroyed, redirect to posts_url
      already_destroy = 1
    end

    if already_destroy == 1
      respond_to do |format|
        format.html { redirect_to users_url }
        format.json { head :no_content }
      end
    else
      redirect_to users_url, notice: 'action not allowed'
    end

    already_destroy = 1




  end

end
