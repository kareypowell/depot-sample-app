class LineItemsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:create]
  before_action :set_line_item, only: [:show, :edit, :update, :destroy]

  # GET /line_items
  # GET /line_items.json
  def index
    @line_items = LineItem.all
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
  end

  # GET /line_items/new
  def new
    @line_item = LineItem.new
  end

  # GET /line_items/1/edit
  def edit
  end

  # POST /line_items
  # POST /line_items.json
  def create
    product = Product.find(params[:product_id])
    @line_item = @cart.add_product(product.id)

    # reset counter once item is added to cart
    session[:store_index_counter] = 0

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_url }
        format.js { @current_item = @line_item }
        format.json { render action: 'show', status: :created, location: @line_item }
      else
        format.html { render action: 'new' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_items/1
  # PATCH/PUT /line_items/1.json
  def update
    respond_to do |format|
      if @line_item.update(line_item_params)
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item = LineItem.find(params[:id])
    @current_cart = current_cart

    if @line_item.quantity > 1
      @line_item.update_attributes(quantity: @line_item.quantity - 1)
    else
      @line_item.destroy
    end

    respond_to do |format|
      if @current_cart.line_items.count.zero?
        format.html { redirect_to store_url, notice: "Your cart is currently empty" }
        format.json { head :no_content }
      else
        format.html { redirect_to store_url, notice: "Item removed" }
        format.json { head :no_content }
      end
    end
  end

  # Decrease line item amount in the cart
  def decrement
    @cart = current_cart
    @line_item = @cart.decrement_line_item_quantity(params[:id])

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_path, notice: 'Line item was successfully updated.' }
        format.js   { @current_item = @line_item }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.js   { @current_item = @line_item }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # Increase line item amount in the cart
  def increment
    @cart = current_cart
    @line_item = @cart.increase_line_item_quantity(params[:id])

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to store_path, notice: 'Line item was successfully updated.' }
        format.js   { @current_item = @line_item }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.js   { @current_item = @line_item }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_item_params
      params.require(:line_item).permit(:product_id)
    end

    # Get the current_cart object
    def current_cart
      Cart.find(session[:cart_id])
    end
end
