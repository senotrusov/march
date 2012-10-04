
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


class DocumentsController < ApplicationController
  
  # GET /board
  def index
    # TODO: include sections?
    @documents = Document.eager.alive.ordered.where(board_id: @board.id).includes(:sections)

    respond_to do |format|
      format.html
    end
  end

  # GET /board/1
  def show
    @document = Document.eager.alive.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  # GET /board/new
  def new
    @document = Document.new sections: [Section.new(title: 'Comments', frame: 0)]

    respond_to do |format|
      format.html
    end
  end

  # GET /board/1/edit
  def edit
    @document = Document.alive.find(params[:id])
    authorize :update, @document
  end

  # POST /board
  def create
    @document = Document.new params[:document]

    if @document.valid?
      Document.transaction do
        
        require_poster

        @document.poster = @poster
        @document.identity_id = Identity.next_id
        @document.poster_addr = request.remote_ip
        @document.board = @board

        @document.save!

        @document.identity = Identity.create_for_document!(@document)

        @document.sections.each do |section|
          section.assign_self_and_paragraphs_identity @document.identity, request.remote_ip
          section.document = @document
          section.save!
        end

        @document.save! unless @document.sections.empty?

      end # of transaction

      respond_to do |format|
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
      end

    else
      respond_to do |format|
        format.html { render action: "new" }
      end
    end

  end

  # PUT /board/1
  def update
    @document = Document.alive.find(params[:id]) # TODO eager load

    authorize :update, @document

    
    sections = (document_attrs = params.required_hash(:document)).extract_array(:sections)

    @document.assign_attributes document_attrs


    section_ids = sections.map {|section_attrs| section_attrs[:id].to_i} - [0]
    @document.sections.each do |section|
      section.mark_as_deleted unless section_ids.include?(section.id)
    end


    @document.clear_framed_sections

    sections.each do |section_attrs|

      # Determine - is it a new section or not (based on 'id' attribute presence)
      if (section_id = section_attrs[:id].to_i) > 0

        unless section = @document.sections.detect {|s| s.id == section_id }
          # Section with submitted id does not exists in document
          raise(ActiveRecord::RecordNotSaved)
        end

        next if section.deleted_mark?

        # There are no paragraphs expected to be in section_attrs for existing section
        section.assign_attributes section_attrs
      else
        section = @document.sections.build section_attrs
      end

      @document.push_framed_section section
    end
    
    # TODO: When editing existing records, their validations does not called by @document.valid?
    # See activerecord-3.2.5/lib/active_record/autosave_association.rb
    if @document.valid? && (sections_is_valid = @document.sections.all? {|section| section.valid? })

      Document.transaction do
        @document.sections.each do |section|
          if section.save_needed?
            section.assign_self_and_paragraphs_identity(@document.identity, request.remote_ip) if section.new_record?
            section.save!
          end
        end
        @document.save! if @document.save_needed?
      end

      respond_to do |format|
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
      end

    else
      if !sections_is_valid && !@document.errors.added?(:sections, 'is invalid')
        @document.errors.add(:sections, 'is invalid')
      end

      respond_to do |format|
        format.html { render action: "edit" }
      end
    end

  end

  # DELETE /board/1
  def destroy
    @document = Document.alive.find(params[:id])

    authorize :destroy, @document

    @document.mark_as_deleted
    @document.save!

    respond_to do |format|
      format.html { redirect_to documents_url }
    end
  end

end
