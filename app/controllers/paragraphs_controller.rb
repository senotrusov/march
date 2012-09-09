
class ParagraphsController < ApplicationController
  def show
    @paragraph = Paragraph.find(params[:id])

    if @paragraph.deleted?
      not_found
    else
      respond_to do |format|
        format.html { render :layout => !request.xhr? }
      end
    end

  end
end
