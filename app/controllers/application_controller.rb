class ApplicationController < ActionController::Base
  protect_from_forgery

  RESPONSE_403 = File.read(Rails.root+'public'+'403.html')

  def forbidden
    render :text => RESPONSE_403, :layout => false, :status => 403
  end
end
