
class SectionsController < ApplicationController
  def show
    @section = Section.find(params[:id])

    respond_to do |format|
      if @section.document.deleted
      	not_found
      else
	    format.html { render :layout => !request.xhr? }
	  end
    end
  end
end
