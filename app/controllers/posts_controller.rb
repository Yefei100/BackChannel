class PostsController < ApplicationController
  # GET /posts
  # GET /posts.json
  def index
    @search = Post.search(params[:q])

    if params[:tag]
      @posts = Post.tagged_with(params[:tag])
    elsif @search
      @posts = @search.result
    else
      @posts = Post.all
    end

   # calculate score for most activated post
    seven_day_ago = Time.now - 7*24*60*60
    last_7_day_post = Post.all.select{ |post| post.last_update_time > seven_day_ago }
    # top_posts = last_7_day_post.each{ |post| post.score = (post.last_update_time - seven_day_ago)/(7*60*60) + post.total_vote_count*0.3+post.post_vote_count*0.7 }
    top_posts = last_7_day_post.each{ |post| post.score = (post.last_update_time - seven_day_ago)/(7*60*60) + post.total_vote_count * 0.3 + post.post_vote_count * 0.7 ; puts post.score}
    @show_top = top_posts.sort{ |post1, post2| post1.score <=> post2.score }
    @most_activated_post = @show_top.reverse.take(10)

    # all posts sort by update time
    @all_posts_sort_by_update = @posts.sort{|post1, post2| post1.last_update_time <=> post2.last_update_time }.reverse

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @post = Post.find(params[:id])
    session[:reply_to_post_id] = @post.id
    session[:vote_post_id] = @post.id
    session[:vote_comment_id] = nil
    @comments_for_post = Comment.all.select{ |x| x.post_id == @post.id }

    # count the vote for the post, count the vote for the post and its comments
    # count by algorithm
    # @vote_number_for_the_post = Vote.all.select{ |x| x.post_id == @post.id }.count
    # vote_number_for_related_comments = @comments_for_post.inject(0){ |x,y| x + Vote.all.select{ |z| z.comment_id == y.id }.count }
    # @vote_number_total = @vote_number_for_the_post +vote_number_for_related_comments
    # ---------------------------------------------------------------------------


    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.json
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
    # allowed_edit = 1 => not allowed to edit
    # allowed_edit = 0 => allowed to edit

    allowed_edit = 1


    if session[:user_id] && !User.find_by_id(session[:user_id]).nil?
      if session[:user_id] == @post.user_id
        allowed_edit = 0
      end
      if User.find_by_id(session[:user_id]).isadmin
        allowed_edit = 0
      end
    end

    if allowed_edit == 1
      redirect_to @post, notice: 'You can not edit other user\'s post.'
    end
    allowed_edit = 1
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(params[:post])
    @post.user_id = session[:user_id]
    @post.last_update_time = Time.now

    # init the number of votes for the post
    @post.post_vote_count = 0

    # init the number of votes for the post's reply
    @post.total_vote_count = 0
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render json: @post, status: :created, location: @post }
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    @post = Post.find(params[:id])
    @post.last_update_time = Time.now

    respond_to do |format|
      if session[:user_id] == @post.user_id && @post.update_attributes(params[:post])
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post = Post.find(params[:id])

    # check user authorize: is post owner? or admin?

    if @post.user_id == session[:user_id] || User.find_by_id(session[:user_id]).isadmin
      # destroy related votes
      @votes = Vote.all
      @Connected_votes = @votes.select{|x| x.post_id == @post.id }
      @Connected_votes.each { |x| x.destroy }

      # find all the reply of the post
      @find_comment_for_delete = Comment.all.select{ |x| x.post_id == @post.id }
      # delete all the found reply and delete all the votes for the reply
      @find_comment_for_delete.each { |x|
        @find_comment_connect_vote = Vote.all.select { |y| y.comment_id == x.id }
        @find_comment_connect_vote.each { |z| z.destroy }
        x.destroy}

      @post.destroy
      respond_to do |format|
        format.html { redirect_to posts_url }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to @post, notice: 'You can not destroy other user\'s post.' }
        format.json { head :no_content }
      end
    end



  end
end
