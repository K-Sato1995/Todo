class Admin::UsersController < Admin::ApplicationController
  before_action :admin_user!

  def index
    @users = User.all
  end

  private

  def admin_user!
    raise 'アドミンユーザーのみアクセスが許可されています。' unless current_user.admin?
  end
end
