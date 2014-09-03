module API
  class ParentsController < ApplicationController

    def show
      parent = Parent.find(params[:id])
      render json: parent, status: 200
    end

  end
end
