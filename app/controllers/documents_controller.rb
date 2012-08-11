
class DocumentsController < ApplicationController
  # GET /documents
  # GET /documents.json
  def index
    # TODO: Do not include sections
    @documents = Document.alive.ordered.where(board_id: @board.id).includes(:sections)

    respond_to do |format|
      format.html
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    @document = Document.alive.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  # GET /documents/new
  # GET /documents/new.json
  def new
    @document = Document.new
    @sections = [Section.new(title: 'Comments', frame: 0)]

    respond_to do |format|
      format.html
    end
  end

  # GET /documents/1/edit
  def edit
    @document = Document.alive.find(params[:id])

    @skip_sections = true

    return forbidden unless @poster && @poster.id == @document.poster_id
  end

  # POST /documents
  # POST /documents.json
  def create
    params.require_hash :document

    all_paragraphs = []

    if @sections = params[:document].extract_array(:sections)
      @sections.map! do |s|
        paragraphs = s.extract_array(:paragraphs)
        s.checkbox! :public_writable, :contributor_writable

        Section.new(s).tap do |section|
          paragraphs && all_paragraphs.concat(paragraphs.map{|p|section.paragraphs.build(p)})
        end
      end
    end

    @document = Document.new params[:document]

    validate = [@document]
    validate.concat(@sections + all_paragraphs) if @sections

    if valid = validate.map{|i| i.valid? }.all?
      Document.transaction do
        
        require_poster

        @document.poster = @poster
        @document.identity_id = Identity.next_id
        @document.poster_addr = request.remote_ip
        @document.board = @board

        @document.save!

        @document.identity = Identity.create_for_document!(@document)

        if @sections
          (@sections + all_paragraphs).each {|i| i.assign_identity @document.identity, request.remote_ip }

          @sections.each {|s| s.document = @document; s.save! }

          @sections.each {|s| (@document.sections_framing[s.frame] ||= []).push(s.id) }
          @document.save!
        end

      end # transaction
    end

    respond_to do |format|
      if valid
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end

  end

  # PUT /documents/1
  # PUT /documents/1.json
  def update
    @document = Document.alive.find(params[:id])

    return forbidden unless @poster && @poster.id == @document.poster_id

    respond_to do |format|
      if @document.update_attributes(params[:document])
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document = Document.alive.find(params[:id])

    return forbidden unless @poster && @poster.id == @document.poster_id

    @document.deleted = true
    @document.deleted_at = Time.zone.now
    @document.save!

    respond_to do |format|
      format.html { redirect_to documents_url }
    end
  end
end
