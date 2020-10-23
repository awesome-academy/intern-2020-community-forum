class Admin::UsersController < AdminController
  before_action :authenticate_user!
  before_action :load_user, except: :index
  before_action :check_params, :get_users, only: :index
  before_action :admin_user

  include UsersHelper

  add_breadcrumb I18n.t("users.breadcrumbs.user"), :admin_users_path

  def index
    search_element "User"
    session[:user_filtered] = @users.ids
  end

  def show
    add_breadcrumb I18n.t("users.breadcrumbs.show")
  end

  def edit
    add_breadcrumb I18n.t("posts.breadcrumbs.edit")
  end

  def update
    if @user.update_without_password user_params
      flash[:notice] = t "users.update.success"
      redirect_to admin_users_path
    else
      flash[:alert] = t "users.update.fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = t "users.controller.delete"
      redirect_to admin_users_url
    else
      flash[:alert] = t "users.controller.delete_fail"
      redirect_to admin_users_path
    end
  end

  private

  def user_params
    params.require(:user).permit User::PERMIT_ATTRIBUTES
  end

  def get_users
    @q = User.ransack params[:q]
    @users = @q.result.order_created_at
               .page(params[:page]).per Settings.user.page
  end

  def check_params
    return unless params.dig(:q, :higher).eql? Settings.not_higher

    params[:q][:posts_count_lt] = params[:q][:posts_count_gteq]
    params[:q].delete :posts_count_gteq
  end
end
