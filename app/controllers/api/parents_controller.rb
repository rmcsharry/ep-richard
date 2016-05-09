module API
  class ParentsController < ApplicationController

    def show
      parent = Parent.find_by_slug(params[:id])
      session[:slug] = params[:id]
      render json: parent, status: 200
    end

  end
end
