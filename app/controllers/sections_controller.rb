
class SectionsController < ApplicationController
  def show
    @section = Section.find_any_instance!(params[:id])

    respond_to do |format|
      format.html { render :layout => !request.xhr? }
    end
  end
end
