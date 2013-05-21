class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart
  
  def index
  	@products = Product.order(:title)

  	# track the number of times this action has been visited
  	store_catalog_access_count
  end

  private

  	def store_catalog_access_count
  		session[:store_index_counter] ||= 0
  		session[:store_index_counter] += 1
  	end
end
