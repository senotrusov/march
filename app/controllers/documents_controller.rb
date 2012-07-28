
class DocumentsController < ApplicationController
  before_filter do
    @boards = Board.ordered
    @board = @boards.detect {|board| board.slug == params[:board_slug]}
    
    unless @board
      respond_to do |format|
        format.html { render text: "Board not found", status: :not_found }
      end
    end

    if session[:poster]
      @poster = Poster.find_by_session_key(session[:poster])
    end
  end

  def require_poster
    unless @poster
      @poster = Poster.create!({
        sign_up_addr:      request.remote_ip,
        last_sign_in_at:   Time.zone.now,
        last_sign_in_addr: request.remote_ip,
        session_key:       Digest::SHA2.hexdigest("#{Time.now.to_f}#{rand}")}, without_protection: true)

      session[:poster] = @poster.session_key
    end
  end

  def default_url_options options = nil
    { board_slug: @board.slug }
  end


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

    respond_to do |format|
      format.html
    end
  end

  # GET /documents/1/edit
  def edit
    @document = Document.alive.find(params[:id])

    return forbidden unless @poster && @poster.id == @document.poster_id
  end

  # POST /documents
  # POST /documents.json
  def create
    Document.transaction do
      @document = Document.new params[:document]

      if @document.valid?
        require_poster

        @document.poster = @poster
        @document.poster_identity_id = PosterIdentity.next_id
        @document.poster_addr = request.remote_ip
        @document.board = @board

        @document.save!

        @document.poster_identity = PosterIdentity.create!({
          id:          @document.poster_identity_id,
          poster:      @poster,
          poster_addr: request.remote_ip,
          document:    @document,
          identity:    1}, without_protection: true)
      end
    end

    respond_to do |format|
      if @document.valid?
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
