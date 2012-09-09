
class SectionsController < ApplicationController
  def show
    @section = Section.find(params[:id])

    if @section.deleted?
      not_found
    else
      respond_to do |format|
        format.html { render :layout => !request.xhr? }
      end
    end

  end
end
