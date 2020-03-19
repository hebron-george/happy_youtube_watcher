class ApplicationController < ActionController::Base
  protect_from_forgery

  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
