
class ParagraphsController < ApplicationController
  def show
    @paragraph = Paragraph.find_any_instance!(params[:id])

    respond_to do |format|
      format.html { render :layout => !request.xhr? }
    end
  end

  def destroy
    @paragraph = Paragraph.find(params[:id])

    raise(ActiveRecord::RecordNotFound, "Couldn't find Paragraph with id=#{@paragraph.id}") if @paragraph.deleted?

    authorize :destroy, @paragraph

    @paragraph.mark_as_deleted
    @paragraph.save!

    respond_to do |format|
      format.json { head :no_content }
    end
  end
end
