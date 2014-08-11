class ProductsController < MerchantApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    warehouse_id = if params[:warehouse_id] then params[:warehouse_id] else current_merchant_account.current_warehouse_id end
    @products = Product.where(warehouse_id: warehouse_id)
  end

  def product_of
    @products = Product.where(product_code: params[:product_code], skull_id: params[:skull_id], warehouse_id: params[:warehouse_id])
  end


  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      render json:@products, status: 201
    else
      render {}
    end
  end

  def update
    if @product.update(product_params)
      render json: @products, status: 204
    else
      render {}
    end
  end


  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params.require(:product).permit(:product_code, :skull_id, :provider_id, :warehouse_id, :import_id, :name, :import_quality, :available_quality, :instock_quality, :import_price, :expire)
  end

end
