class UsersController < ApplicationController
  before_action :find_id, only: [:destroy, :update, :show]
  before_action :ensure_admin, only: [:destroy]

  def new
    @user = User.new
  end

  def show
    @tasks = @user.tasks.all
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '登録が完了しました。'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def update
    @user.update(user_params)
    if @user.save
      flash[:warning] = 'ユーザーの編集が成功しました。'
      redirect_to admin_users_path
    else
      render 'edit'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
    @user.destroy
    flash[:danger] = 'ユーザーの削除が完了しました。'
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end

  def find_id
    @user = User.find(params[:id])
  end

  def ensure_admin
    raise '最後のユーザーは削除できません。' if admin_user_count == 1
  end
end
