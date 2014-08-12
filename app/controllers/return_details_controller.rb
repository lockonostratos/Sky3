class ReturnDetailsController < ApplicationController
  before_action :set_return_detail, only: [:show, :edit, :update, :destroy]

  # GET /return_details
  # GET /return_details.json
  def index
    @return_details = ReturnDetail.all
    respond_to do |format|
      format.html
      format.json { render :json => @return_details }
    end
  end

  # GET /return_details/1
  # GET /return_details/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render :json => @return_detail }
    end
  end

  # GET /return_details/new
  def new
    @return_detail = ReturnDetail.new
  end

  # GET /return_details/1/edit
  def edit
  end

  # POST /return_details
  # POST /return_details.json
  def create
    @return_detail = ReturnDetail.new(return_detail_params)

    respond_to do |format|
      if @return_detail.save
        format.html { redirect_to @return_detail, notice: 'Return detail was successfully created.' }
        format.json { render action: 'show', status: :created, location: @return_detail }
      else
        format.html { render action: 'new' }
        format.json { render json: @return_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /return_details/1
  # PATCH/PUT /return_details/1.json
  def update
    respond_to do |format|
      if @return_detail.update(return_detail_params)
        format.html { redirect_to @return_detail, notice: 'Return detail was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @return_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /return_details/1
  # DELETE /return_details/1.json
  def destroy
    @return_detail.destroy
    respond_to do |format|
      format.html { redirect_to return_details_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_return_detail
      @return_detail = ReturnDetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def return_detail_params
      params.require(:return_detail).permit(:return_id, :return_product_id, :return_quality, :type_return, :product_id, :price)
    end
end
