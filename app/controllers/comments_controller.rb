class CommentsController < ApplicationController


  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])
    session[:vote_post_id] = nil
    session[:vote_comment_id] = @comment.id
    @belong_to_post = Post.find_by_id(@comment.post_id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new
    #@post= Post.find(params[:format])

    if session[:reply_to_post_id]
      @comment.title = "Re: " + Post.find_by_id(session[:reply_to_post_id]).title.to_s
      @comment.post_id = session[:reply_to_post_id]

    end



    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment }
    end

  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
    @post = Post.find_by_id(@comment.post_id)

    # allowed_edit = 1 => not allowed to edit
    # allowed_edit = 0 => allowed to edit

    allowed_edit = 1

    if session[:user_id] && !User.find_by_id(session[:user_id]).nil?
      # allowed comment owner to edit the comment
      if session[:user_id] == @comment.user_id
        allowed_edit = 0
      end
      # allowed administrator to edit the comment
      if User.find_by_id(session[:user_id]).isadmin
        allowed_edit = 0
      end
    end
    if allowed_edit == 1
      redirect_to @post, notice: 'You can not edit other user\'s comment.'
    end
    allowed_edit = 1

  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(params[:comment])
    @comment.post_id = session[:reply_to_post_id]
    session[:reply_to_post_id] = nil
    puts session[:reply_to_post_id].to_s
    @comment.user_id = session[:user_id]

    #init the number of votes for the comment
    @comment.vote_number = 0

    # update the last_update_time in the Post table
    @comment_belong_to_post = Post.find_by_id(@comment.post_id)
    @comment_belong_to_post.last_update_time = Time.now
    @comment_belong_to_post.save

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { render action: "new" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])
    # update the last_update_time in the Post table
    @comment_belong_to_post = Post.find_by_id(@comment.post_id)
    @comment_belong_to_post.last_update_time = Time.now
    @comment_belong_to_post.save

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])

    # @comment belogns to @post_to_show
    @belong_to_post = Post.find_by_id(@comment.post_id)
    #check user authorize: is post owner? or admin?

    if @comment.user_id == session[:user_id] || User.find_by_id(session[:user_id]).isadmin
      # destroy related votes
      @votes = Vote.all
      @Connected_votes = @votes.select{|x| x.comment_id == @comment.id }
      # count the number of votes related to the comment, and then substrate the count from the total vote number in post table
      destroy_votes_count = @Connected_votes.count

      @belong_to_post.total_vote_count -= destroy_votes_count
      @belong_to_post.save

      # destroy related votes
      @Connected_votes.each { |x| x.destroy }




      @comment.destroy
      respond_to do |format|
        format.html { redirect_to post_url(@belong_to_post) }
        format.json { head :no_content }
      end
    else

      respond_to do |format|
        format.html { redirect_to @belong_to_post, notice:'You cannot destroy other user\'s comment' }
        format.json { head :no_content }
      end
    end


  end
end
