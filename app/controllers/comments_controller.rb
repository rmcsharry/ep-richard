class CommentsController < ApplicationController

  def index
    redirect_to admin_path
  end

  def show
    redirect_to admin_path
  end

  def destroy
    comment = Comment.where(id: params[:id])[0]
    if current_admin && comment.pod.id == current_admin.pod.id
      comment.destroy
      redirect_to pod_admin_comments_path
    else
      redirect_to pod_admin_comments_path
    end
  end

end
