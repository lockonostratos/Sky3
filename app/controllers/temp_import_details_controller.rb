class TempImportDetailsController < MerchantApplicationController
  before_action :set_temp_import_detail, only: [:show, :edit, :update, :destroy]

  # GET /temp_import_details
  # GET /temp_import_details.json
  def index
    @temp_import_details = TempImportDetail.all
  end

  # GET /temp_import_details/1
  # GET /temp_import_details/1.json
  def show
  end

  # GET /temp_import_details/new
  def new
    @temp_import_detail = TempImportDetail.new
  end

  # GET /temp_import_details/1/edit
  def edit
  end

  # POST /temp_import_details
  # POST /temp_import_details.json
  def create
    @temp_import_detail = TempImportDetail.new(temp_import_detail_params)

    respond_to do |format|
      if @temp_import_detail.save
        format.html { redirect_to @temp_import_detail, notice: 'Temp import detail was successfully created.' }
        format.json { render action: 'show', status: :created, location: @temp_import_detail }
      else
        format.html { render action: 'new' }
        format.json { render json: @temp_import_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /temp_import_details/1
  # PATCH/PUT /temp_import_details/1.json
  def update
    respond_to do |format|
      if @temp_import_detail.update(temp_import_detail_params)
        format.html { redirect_to @temp_import_detail, notice: 'Temp import detail was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @temp_import_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /temp_import_details/1
  # DELETE /temp_import_details/1.json
  def destroy
    @temp_import_detail.destroy
    respond_to do |format|
      format.html { redirect_to temp_import_details_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_temp_import_detail
      @temp_import_detail = TempImportDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def temp_import_detail_params
      params[:temp_import_detail]
    end
end
