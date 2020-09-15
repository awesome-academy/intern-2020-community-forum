class Admin::PostsController < AdminController
  before_action :logged_in_user
  before_action :load_post, except: %i(index new create)
  before_action :load_element, :post_include, only: :index

  include PostsHelper

  add_breadcrumb I18n.t("posts.breadcrumbs.post"), :admin_posts_path

  def index
    @posts = @posts.order_updated_at
                   .by_title(params[:title])
                   .by_status(params[:status])
                   .by_user_id(params[:user_id])
                   .by_topic_id(params[:topic_id])
                   .page(params[:page]).per Settings.post.page
  end

  def new
    add_breadcrumb I18n.t("posts.breadcrumbs.new")
    @post = current_user.posts.build
  end

  def show; end

  def create
    @post = current_user.posts.build post_params
    if @post.save
      flash[:info] = t "post.controller.create_success"
      redirect_to admin_posts_path
    else
      flash.now[:danger] = t "post.controller.create_failed"
      render :new
    end
  end

  def edit
    add_breadcrumb I18n.t("posts.breadcrumbs.edit")
  end

  def update
    if @post.update post_params
      flash[:success] = t "users.update.success"
      redirect_to admin_posts_path
    else
      flash[:danger] = t "users.update.fail"
      render :edit
    end
  end

  def destroy
    if @post.destroy
      flash[:success] = t "post.controller.deleted_success"
    else
      flash.now[:danger] = t "post.controller.deleted_error"
    end
    redirect_to admin_posts_path
  end

  private

  def post_params
    params.require(:post).permit Post::POST_PARAMS
  end

  def load_post
    @post = Post.find_by id: params[:id]
    return if @post

    flash[:danger] = t "post.controller.not_found"
    redirect_to admin_posts_path
  end

  def correct_writer
    return if current_user.id.eql? @post.user.id

    flash[:danger] = t "post.controller.not_allow"
    redirect_to admin_posts_path
  end

  def load_element
    @users = User.all
    @topics = Topic.all
  end

  def post_include
    @posts = Post.includes :user, :topic
  end
end
