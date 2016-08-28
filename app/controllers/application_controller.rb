class ApplicationController < ActionController::API
  include ::ActionController::Cookies

  rescue_from ActiveRecord::RecordNotFound do |e|
    render status: 404
  end
end
