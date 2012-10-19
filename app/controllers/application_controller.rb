
#  Copyright 2012 Stanislav Senotrusov <stan@senotrusov.com>
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.


class ApplicationController < ActionController::Base

  after_filter :iframe_upload_response

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
    unless model.__send__("can_#{action}?", @poster)
      raise(Unauthorized, "Unauthorized action #{action} on #{model.class} ##{model.id}")
    end
  end

  before_filter :load_poster

  def load_poster
    @poster = Poster.find_by_session_key(session[:poster]) if session[:poster]
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


  before_filter :load_board
  
  def load_board
    if params.has_key?(:board_slug)
      @board = Board.find_by_slug(params[:board_slug])

      not_found unless @board
    end
  end

  def default_url_options options = nil
    { board_slug: @board && @board.slug }
  end

end
