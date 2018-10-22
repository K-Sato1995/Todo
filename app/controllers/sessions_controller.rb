class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in(user)
      redirect_to root_path
      flash[:success] = 'ログインが完了しました。'
    else
      flash.now[:danger] = 'メールアドレスまたはパスワードに誤りがあります。'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
