class ApplicationController < ActionController::Base

  protect_from_forgery

  RESPONSE_403 = File.read(Rails.root + 'public' + '403.html')
  RESPONSE_404 = File.read(Rails.root + 'public' + '404.html')

  def forbidden
    render :text => RESPONSE_403, :layout => false, :status => 403
  end

  def not_found
    render :text => RESPONSE_404, :layout => false, :status => 404
  end

  class Unauthorized < StandardError
  end

  rescue_from Unauthorized, with: :forbidden

  def authorize action, model
    unless @poster && model.__send__("can_#{action}?", @poster)
      raise(Unauthorized, "Unauthorized action #{action} on #{model.class} ##{model.id}")
    end
  end


  before_filter do
    @boards = Board.ordered
    @board = @boards.detect {|board| board.slug == params[:board_slug]}
    
    unless @board
      respond_to do |format|
        format.html { render text: "Board not found", status: :not_found }
      end
    end

    if session[:poster]
      @poster = Poster.find_by_session_key(session[:poster])
    end
  end

  def require_poster
    unless @poster
      @poster = Poster.create!({
        sign_up_addr:      request.remote_ip,
        last_sign_in_at:   Time.zone.now,
        last_sign_in_addr: request.remote_ip,
        session_key:       Digest::SHA2.hexdigest("#{Time.now.to_f}#{rand}")}, without_protection: true)

      session[:poster] = @poster.session_key
    end
  end

  def default_url_options options = nil
    { board_slug: @board.slug }
  end

end
