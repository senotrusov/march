
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


class ParagraphsController < ApplicationController

  # GET /board/paragraphs/1
  def show
    @paragraph = Paragraph.find_any_instance!(params[:id])

    respond_to do |format|
      format.html { render :layout => !request.xhr? }
    end
  end

  # DELETE /board/paragraphs/1
  def destroy
    @paragraph = Paragraph.find(params[:id]).ensure_not_deleted

    authorize :destroy, @paragraph

    @paragraph.mark_as_deleted
    @paragraph.save!

    respond_to do |format|
      format.json { head :no_content }
    end
  end

end
