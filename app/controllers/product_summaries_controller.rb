class ProductSummariesController < MerchantApplicationController
  before_action :set_product_summary, only: [:show, :edit, :update, :destroy]

  def index
    @product_summaries = ProductSummary.products_of(current_merchant_account.current_warehouse_id)
  end

  def import_availables
    current_product_summaries = ProductSummary.where(warehouse_id:current_merchant_account.current_warehouse_id)
    current_temproduct = TempProduct.where(product_summary_id:current_product_summaries.pluck(:id), merchant_account_id:current_merchant_account.id)
    product_summaries = []
    current_temproduct.each do |temproduct|
      product_summaries += [current_product_summaries.find(temproduct.product_summary_id)]
    end

    @product_summaries = current_product_summaries - product_summaries
    # @product_summaries = current_product_summaries
    respond_to do |format|
      format.html {render action: 'index'}
      format.json {render json: @product_summaries}
    end
  end

  #
  def show_product_summary
    warehouse_id = if params[:warehouse_id] then params[:warehouse_id] else current_merchant_account.current_warehouse_id end
    @product_summaries = ProductSummary.products_of(warehouse_id)
  end




  # GET /product_summaries/1
  # GET /product_summaries/1.json
  def show
    respond_to do |format|
      format.html { render layout: "account" }
      format.json {render json: @product_summary, root: false}
    end
  end

  def search
    @product_summaries = ProductSummary.search(params)
    # if params[:query].present? then
    #   @product_summaries = ProductSummary.search(params[:query])
    # else
    #   @product_summaries = ProductSummary.where(warehouse_id: current_merchant_account.current_warehouse_id)
    # end

    respond_to do |format|
      format.html
      format.json {render json: @product_summaries}
    end
  end

  # GET /product_summaries/new
  def new
    @product_summary = ProductSummary.new
  end

  # GET /product_summaries/1/edit
  def edit
    respond_to do |format|
      format.html { render layout: "account" }
      format.json {render json: @product_summarie}
    end
  end

  # POST /product_summaries
  # POST /product_summaries.json
  def create
    @product_summary = ProductSummary.new(product_summary_params)
    @product_summary.quality = 0
    respond_to do |format|
      if @product_summary.save
        format.html { redirect_to @product_summary, notice: 'Product summary was successfully created.' }
        format.json { render json: @product_summary }
      else
        format.html { render action: 'new' }
        format.json { render json: { errors: @product_summary } }
      end
    end
  end

  # PATCH/PUT /product_summaries/1
  # PATCH/PUT /product_summaries/1.json
  def update
    respond_to do |format|
      if @product_summary.update(product_summary_params)
        format.html { redirect_to @product_summary, notice: 'Product summary was successfully updated.' }
        format.json { head :no_content }
        # Cập nhật tên của sản phẩm trong bảng Product
        if @product_summary.quality !=0
          # Cập nhật thông tin khi ProductSummary Câp nhật Name vào bảng Product
          @pro = Product.where(
              :product_code => @product_summary.product_code,
              :skull_id => @product_summary.skull_id,
              :warehouse_id => @product_summary.warehouse_id)
          @pro.each do |pro|
            Product.update(pro.id,name:@product_summary.name)
          end
        end
      else
        format.html { render action: 'edit' }
        format.json { render json: @product_summary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_summaries/1
  # DELETE /product_summaries/1.json
  def destroy
    @product_summary.destroy
    respond_to do |format|
      format.html { redirect_to product_summaries_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_product_summary
    @product_summary = ProductSummary.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_summary_params
    params.require(:product_summary).permit(:product_code, :skull_id, :warehouse_id, :name, :merchant_account_id, :quality, :price)
  end
end
