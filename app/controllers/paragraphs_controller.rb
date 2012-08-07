
class ParagraphsController < ApplicationController
  def show
    @paragraph = Paragraph.find(params[:id])

    respond_to do |format|
      format.html { render :layout => !request.xhr? }
    end
  end
end
