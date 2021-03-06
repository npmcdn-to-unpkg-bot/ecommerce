class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
before_action :authenticate_user!, except: [:index, :show]
before_action :authenticate_editor!, only: [:new, :create, :update]
before_action :authenticate_admin!, only: [:destroy, :publish, :edit]
  # GET /products
  # GET /products.json
  def index
    @productos = Product.all
    @products = Product.order(:name)
  respond_to do |format|
    format.html
    format.csv { send_data @products.to_csv }
    format.xls { send_data @products.to_csv(col_sep: "\t") }
  end
  end

  # GET /products/1
  # GET /products/1.json
  def show

    if user_signed_in? && current_user == @product.user && !params.has_key?(:client)
      @attachment = Attachment.new
      render :admin
    end

  end

  # GET /products/new
  def new

    @product = Product.new
  end

  # GET /products/1/edit
  def edit

  end

  # POST /products
  # POST /products.json
  def create

    @product = current_user.products.new(product_params)

    respond_to do |format|
      if @product.save

        format.html { redirect_to @product, notice: 'El producto ha sido creado con éxito' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Producto actualizado' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Producto eliminado' }
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
      params.require(:product).permit(:name, :pricing, :description, :avatar, :subcategory_id)
    end
end
