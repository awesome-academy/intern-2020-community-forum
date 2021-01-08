class PostsController < ApplicationController
  before_action :authenticate_user!, except: %i(index show)

  authorize_resource Post

  before_action :find_post, except: %i(new create index)
  before_action :correct_user, only: %i(edit update destroy)

  def index; end

  def show
    Post.update_counters [@post.id], view: Settings.post.inc_per_view
    @commentable = @post
    @comments = @commentable.post_comments.includes(:user).order_created_at
  end

  def new
    @post = Post.new
    @post.tags.build
  end

  def create
    @post = current_user.posts.build post_params
    if @post.save
      flash[:notice] = t ".post_created"
      FollowerPostingWorker.perform_async @post.id
      redirect_to current_user
    else
      flash[:alert] = t ".post_create_failed"
      render :new
    end
  end

  def edit
    @post.tags.build
  end

  def update
    if @post.update post_params
      flash[:notice] = t ".post_updated"
      redirect_to current_user
    else
      flash[:alert] = t ".post_update_failed"
      render :edit
    end
  end

  def destroy
    if @post.destroy
      flash[:notice] = t ".post_destroyed"
    else
      flash[:alert] = t ".post_destroy_failed"
    end
    redirect_to current_user
  end

  private

  def post_params
    params.require(:post).permit Post::POST_PARAMS
  end

  def find_post
    @post = Post.find_by id: params[:id]
    return if @post

    flash[:alert] = t ".not_found"
    redirect_to root_url
  end

  def correct_user
    redirect_to root_url unless current_user.author? @post
  end
end
