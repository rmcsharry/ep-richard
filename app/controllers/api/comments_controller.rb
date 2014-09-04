module API
  class CommentsController < ApplicationController
    protect_from_forgery with: :null_session

    def index
      if params[:game] && params[:parent]
        game = Game.find(params[:game])
        parent = Parent.find(params[:parent])
        pod = parent.pod
        comments = game.comments_for_pod(pod.id)
        render json: comments, status: 200
      end
    end

    def create
      comment = Comment.new
      comment.body = params[:body]
      comment.game = Game.find(1)
      comment.parent = Parent.find(8)
      comment.save
      render json: comment, status: 200
    end

  end
end
