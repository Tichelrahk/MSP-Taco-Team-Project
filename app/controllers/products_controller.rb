class ProductsController < ApplicationController
	def index
		@products = Product.where("active = true")
	end

	def create
		price = product_params[:price]
	    @product = Product.new(product_params)
	    @product.active = true
	    price = (price.to_f * 100).to_i
	    @product.price = price
	    if @product.save
	      redirect_to products_path
	    else
	      render :new
	    end
	end

	def new
	end

	def edit
		@product = Product.find(params[:id])
		@product.price = sprintf('%.2f', (@product.price/100).to_f)
	end

	def update
		@product = Product.find(params[:id])
		h = product_params.to_h
		price = h[:price]
		price = (price.to_f * 100).to_i
		h[:price] = price
		puts h
		if @product.update(h)
	      redirect_to products_path
	    else
	      render :edit
	    end
	end

	private

    def product_params
    	params.require(:product).permit(:name, :stock, :price, :active)
    end
end
