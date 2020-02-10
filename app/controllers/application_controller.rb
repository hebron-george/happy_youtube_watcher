class ApplicationController < ActionController::Base
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
  alias_method :render_404, :not_found

  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
