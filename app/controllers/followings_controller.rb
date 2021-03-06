class FollowingsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource Relationship

  before_action :find_user, :correct_user, only: :index

  def index; end
end
