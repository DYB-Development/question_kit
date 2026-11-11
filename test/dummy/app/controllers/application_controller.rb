class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def require_a_customer
    head :forbidden unless current_customer
  end

  def current_customer
    Customer.find_by(id: request.headers["X-Customer"])
  end
end
