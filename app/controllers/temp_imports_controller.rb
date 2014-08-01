class TempImportsController < MerchantApplicationController
  before_action :set_temp_import, only: [:show, :edit, :update, :destroy]
  layout 'account'

  # GET /temp_imports
  # GET /temp_imports.json
  def index
    @temp_imports = TempImport.find_by_merchant_account_id(current_merchant_account.id)
    render json: @temp_imports, root: false
  end

  # GET /temp_imports/1
  # GET /temp_imports/1.json
  def show
    render json: @temp_import, root: false;
  end

  # GET /temp_imports/new
  def new
    @temp_import = TempImport.new
  end

  # GET /temp_imports/1/edit
  def edit
  end

  # POST /temp_imports
  # POST /temp_imports.json
  def create
    @temp_import = TempImport.new(temp_import_params)

    respond_to do |format|
      if @temp_import.save
        format.html { redirect_to @temp_import, notice: 'Temp import was successfully created.' }
        format.json { render action: 'show', status: :created, location: @temp_import }
      else
        format.html { render action: 'new' }
        format.json { render json: @temp_import.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /temp_imports/1
  # PATCH/PUT /temp_imports/1.json
  def update
    respond_to do |format|
      if @temp_import.update(temp_import_params)
        format.html { redirect_to @temp_import, notice: 'Temp import was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @temp_import.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /temp_imports/1
  # DELETE /temp_imports/1.json
  def destroy
    @temp_import.destroy
    respond_to do |format|
      format.html { redirect_to temp_imports_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_temp_import
      @temp_import = TempImport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def temp_import_params
      params.require(:temp_import).permit(:name, :description, :warehouse_id, :merchant_account_id)
    end
end
