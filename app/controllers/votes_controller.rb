class VotesController < ApplicationController
  # GET /votes
  # GET /votes.json
  def index
    @votes = Vote.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @votes }
    end
  end

  # GET /votes/1
  # GET /votes/1.json
  def show
    @vote = Vote.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vote }
    end
  end

  # GET /votes/new
  # GET /votes/new.json
  def new
    @vote = Vote.new
    # by use of verify_vote_right to check whether the user vote himself/herself
    @verify_vote_right = 0

      if session[:user_id] && session[:vote_post_id] && session[:vote_comment_id].nil?
        if Post.find_by_id(session[:vote_post_id]).user_id == session[:user_id]
          @verify_vote_right = 1
        end
      else if session[:user_id] && session[:vote_post_id].nil? && session[:vote_comment_id]
             if Comment.find_by_id(session[:vote_comment_id]).user_id == session[:user_id]
               @verify_vote_right = 1
             end
           end
      end



    if session[:user_id] && @verify_vote_right == 0
      @votes = Vote.find_all_by_user_id(session[:user_id])
      if session[:vote_post_id] && session[:vote_comment_id]
        session[:vote_post_id] = nil
      end
      # check weather a vote from current for this post exits
      if session[:vote_post_id]
        vote_exist = @votes.select{|x| x.post_id == session[:vote_post_id] && x.comment_id.nil? }
        # puts vote_exist[0].nil?
        @go_back_id = session[:vote_post_id]

        if vote_exist[0].nil?
          if session[:vote_post_id] && session[:user_id]
            @vote.post_id = session[:vote_post_id]
            @vote.user_id = session[:user_id]
            @vote.save
            @add_post_count = Post.find_by_id(@vote.post_id)
            @add_post_count.post_vote_count += 1
            @add_post_count.total_vote_count += 1
            @add_post_count.save
            session[:vote_post_id] = nil
          end
        end
      end

      # check weather a vote from current for this comment exits
      if session[:vote_comment_id] && @verify_vote_right == 0
        vote_exist = @votes.select{|x| x.comment_id == session[:vote_comment_id] && x.post_id.nil? }
        #puts vote_exist[0].nil?
        @go_back_id = session[:vote_comment_id]

        if vote_exist[0].nil?
          if session[:vote_comment_id] && session[:user_id] && Comment.find_by_id(session[:vote_comment_id]).post_id != nil
            @vote.comment_id = session[:vote_comment_id]
            @vote.user_id = session[:user_id]
            @vote.save
            #add the total_vote_count term in Post table
            @add_post_count = Post.find_by_id(Comment.find_by_id(@vote.comment_id).post_id)
            @add_post_count.total_vote_count += 1
            @add_post_count.save

            #add vote_number in comment table
            @add_comment_count = Comment.find_by_id(@vote.comment_id)
            @add_comment_count.vote_number += 1
            @add_comment_count.save

            session[:vote_comment_id] = nil
          end
        end
      end
    end

    @verify_vote_right = 0
    session[:vote_post_id] = nil
    session[:vote_comment_id] = nil
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vote }
    end
  end

  # GET /votes/1/edit
  def edit
    @vote = Vote.find(params[:id])
  end

  # POST /votes
  # POST /votes.json
  def create
    @vote = Vote.new(params[:vote])

    respond_to do |format|
      if @vote.save
        format.html { redirect_to @vote, notice: 'Vote was successfully created.' }
        format.json { render json: @vote, status: :created, location: @vote }
      else
        format.html { render action: "new" }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /votes/1
  # PUT /votes/1.json
  def update
    @vote = Vote.find(params[:id])

    respond_to do |format|
      if @vote.update_attributes(params[:vote])
        format.html { redirect_to @vote, notice: 'Vote was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /votes/1
  # DELETE /votes/1.json

  def destroy
    @vote.destroy


    respond_to do |format|
      format.html { redirect_to votes_url }
      format.json { head :no_content }
    end
  end

end
