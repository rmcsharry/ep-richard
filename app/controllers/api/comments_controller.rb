module API
  class CommentsController < ApplicationController
    protect_from_forgery with: :null_session

    def index
      if params[:game] && params[:parent]
        game = Game.find(params[:game])
        parent = Parent.find_by_slug(params[:parent])
        pod = parent.pod
        comments = game.comments_for_pod(pod.id)
        render json: comments, status: 200
      end
    end

    def create
      c_params = params[:comment]
      comment = Comment.new(
        body:      c_params[:body],
        game_id:   c_params[:game_id],
        parent_id: c_params[:parent_id]
      )
      comment.save
      render json: comment, status: 200
    end

  end
end
