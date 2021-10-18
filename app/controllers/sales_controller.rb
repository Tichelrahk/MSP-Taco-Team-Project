class SalesController < ApplicationController
	def index
		@sales = Sale.all
		@products = Product.all
		respond_to do |format|
			format.html
			#format.csv { render text: @root_path/index.to_csv }
			format.csv { send_data @sales.to_csv, filename: "sales-#{Date.today}.csv" }
	end
end

	
	def import 
		sales.import(params[:file])	
		redirect_to sales_path, notice: "uploaded successfully" 
	end

	def about
	end

	def new
	end

	def create
	    @sale = Sale.new(sale_params)
	    if @sale.save
	      redirect_to root_paths
	    else
	      render :new
	    end
	end

	def edit
	end

	def update
	end

	def weekly
		week_ago = Time.now() - 7.days
		@sales = Sale.where(saleTime: (week_ago)..Time.now)
		@items = []
		@sales.each do |sale|
			sale.sale_items.each do |item|
				@items << item
			end
		end

		@total_products_sold = {}
		@sales.each do |sale|
			sale.sale_items.each do |item|
				k = item.product
				value = item.quantity.to_i. + (@total_products_sold[k].to_i)
				@total_products_sold[k] = value
			end
		end

		@week_revenue = 0
		@total_products_sold.each do |k, v|
			@week_revenue = @week_revenue + (k.price * v)
		end

	end

	def monthly
		month_ago = Time.now() - 1.month
		@sales = Sale.where(saleTime: (month_ago)..Time.now)

		@total_products_sold = {}
		@sales.each do |sale|
			sale.sale_items.each do |item|
				k = item.product
				value = item.quantity.to_i. + (@total_products_sold[k].to_i)
				@total_products_sold[k] = value
			end
		end

		@month_revenue = 0
		@total_products_sold.each do |k, v|
			@month_revenue = @month_revenue + (k.price * v)
		end
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
