
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


class SectionsController < ApplicationController

  # GET /board/sections/1
  def show
    @section = Section.find_any_instance!(params[:id])

    respond_to do |format|
      format.html { render :layout => !request.xhr? }
    end
  end

  # PUT /board/sections/1
  def update
    @section = Section.find(params[:id]).ensure_not_deleted
    @document = @section.document

    authorize :create_paragraphs, @section

    paragraphs = params.required_hash(:section).extract_array(:paragraphs)

    @updated_paragraphs = paragraphs.map do |paragraph_attrs|
      @section.proto_or_self.paragraphs.build paragraph_attrs
    end

    if @updated_paragraphs.all? {|paragraph| paragraph.valid? }
      
      Section.transaction do
        require_poster
        identity = Identity.find_or_create_for_document!(@section.document, @poster, request.remote_ip)

        @updated_paragraphs.each do |paragraph|
          paragraph.assign_identity(identity, request.remote_ip)
          paragraph.save!
        end
      end

      respond_to do |format|
        format.html { render 'update', :layout => !request.xhr? }
      end
    else
      respond_to do |format|
        format.html { render 'invalid_update', status: :unprocessable_entity, :layout => !request.xhr? }
      end
    end

  end

end
