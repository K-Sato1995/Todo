class TasksController < ApplicationController
  http_basic_authenticate_with name: ENV['BASIC_AUTH_USERNAME'], password: ENV['BASIC_AUTH_PASSWORD'] if Rails.env.production?
  before_action :authenticate_user!
  before_action :find_id, only: [:destroy, :edit, :update, :show]

  def index
    @q = current_user.tasks.ransack(params[:q])
    task_ids = Task.where(user_id: current_user.id).pluck(:id)
    tag_ids = Tagging.where(task_id: task_ids).pluck(:tag_id)
    @checked = params[:q][:tag_search] if params[:q] && params[:q][:tag_search]
    @tags = Tag.where(id: tag_ids)
    @tasks = @q.result(distinct: true).includes(:tags).order(deadline: :desc).page(params[:page]).per(10)
  end

  def new
    @task = Task.new
  end

  def create
    tags = params[:task][:all_tags].split(',').map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
    @task = Task.new(task_params)
    @task.tags = tags
    if @task.save
      flash[:success] = 'タスクの作成が成功しました。'
      redirect_to root_path
    else
      render 'new'
    end
  end

  def update
    tags = params[:task][:all_tags].split(',').map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
    @task.update(task_params)
    @task.tags = tags
    if @task.save
      flash[:warning] = 'タスクの編集が成功しました。'
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    @task.destroy
    flash[:danger] = 'タスクの削除が完了しました。'
    redirect_to root_path
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :deadline, :state, :priority).merge(user_id: current_user.id)
  end

  def find_id
    @task = current_user.tasks.find(params[:id])
  end
end
