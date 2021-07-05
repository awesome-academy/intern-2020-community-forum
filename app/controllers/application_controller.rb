class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, prepend: true

  check_authorization

  include PublicActivity::StoreController
  include SessionsHelper

  before_action :set_locale, :load_right_sidebar

  helper_method :load_all_notifications, :load_uncheck_notification_count

  def find_user
    @user = User.find_by id: params[:user_id]
    return if @user

    flash[:alert] = t ".not_found"
    redirect_to root_url
  end

  def load_right_sidebar
    @post_sidebar = Post.includes(:user)
                        .order_created_at
                        .on
                        .first Settings.right_bar.new_feeds
    @topics_sidebar = Topic.all
    @celebrities_sidebar = User.all_except(current_user)
                               .order_followers_count
                               .first Settings.right_bar.celebrities
    load_activities_sidebar
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}.merge(super)
  end

  def load_activities_sidebar
    return if current_user.blank?

    @activities_sidebar = current_user.activities
                                      .includes(:trackable)
                                      .order_created_at
                                      .limit Settings.acts.per_page_sidebar
  end

  def load_all_notifications
    current_user.notifications.includes(:user, :post)
                .updated
                .order_created_at
                .take Settings.notifications.page
  end

  def load_uncheck_notification_count
    current_user.notifications.uncheck.updated.count
  end
  ahuhu
end
