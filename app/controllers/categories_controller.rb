class CategoriesController < ApplicationController
  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.json
  def new

    if User.find_by_id(session[:user_id]).isadmin
      @category = Category.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @category }
      end
    else
      redirect_to categories_url
    end

  end

  # GET /categories/1/edit
  def edit
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.json
  def update
    @category = Category.find(params[:id])
    # if allowed_update = 0 => user can edit and update a category
    # if allowed_update = 1 => user cannot edit or update a category
    allowed_update = 1
    if session[:user_id] && !User.find_by_id(session[:user_id]).nil?
      if User.find_by_id(session[:user_id]).isadmin
        allowed_update = 0
      end
    end
    if allowed_update == 0
      respond_to do |format|
        if @category.update_attributes(params[:category])
          format.html { redirect_to @category, notice: 'Category was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @category.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to categories_url, notice: 'action not allowed'
    end
    allowed_update = 1

  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category = Category.find(params[:id])
    Post.find_all_by_category_id(@category.id).each{ |post|
      Comment.find_all_by_post_id(post.id).each{ |comment|
        Vote.find_all_by_comment_id(comment.id).each{ |vote|
          vote.destroy
        }
        comment.destroy
      }
      post.destroy
    }
    @category.destroy

    respond_to do |format|
      format.html { redirect_to categories_url }
      format.json { head :no_content }
    end
  end
end
