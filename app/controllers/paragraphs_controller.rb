
class ParagraphsController < ApplicationController
  def show
    @paragraph = Paragraph.find(params[:id])

    respond_to do |format|
      if @paragraph.deleted?
        not_found
      else
        format.html { render :layout => !request.xhr? }
      end
    end
  end
end
