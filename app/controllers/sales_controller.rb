class SalesController < ApplicationController
	def index
		@sales = Sale.all
		@products = Product.all
	end

	def about
	end

	def new
	end

	def create
	    @sale = Sale.new(sale_params)
	    if @sale.save
	      redirect_to root_path
	    else
	      render :new
	    end
	end

	def edit
	end
	
	def update
	end

	private

	def set_sale
    	@sale = Sale.find(params[:id])
    end

    # Needs work
    def sale_params
    	params.require(:sale).permit(:name, :description, :photo)
    end
  
end
