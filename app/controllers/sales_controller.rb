class SalesController < ApplicationController
	def index
		if params[:query].present?
      		sql_query = "name LIKE :query OR saleTime LIKE :query"
    		@sales = Sale.joins(:sale_items, :products).where(sql_query, query: "%#{params[:query]}%").distinct
    		@products = Product.all
			respond_to do |format|
				format.html
				format.csv { send_data @products.to_csv, filename: "products-#{Date.today}.csv" }
			end
    	else
			@sales = Sale.all
			@products = Product.all
			respond_to do |format|
				format.html
				format.csv { send_data @products.to_csv, filename: "products-#{Date.today}.csv" }
			end
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

	#Still Needs Work
	def create
		error = ""
		products = params[:sales][:products]
		puts(products)
		sale = Sale.new(saleTime: Time.now())
		products.each do |p|
			product = Product.find(p["id"])
			quant = p["quantity"].to_i
			if quant < product.stock
				product.stock - quant
				si = SaleItem.new
				si.product = product
				si.quantity = quant
				si.sale = sale
				si.save()
			else
				error = "not enough stock"
				puts error
			end
		end
		if (error = "" and sale.save)
			redirect_to root_path
		else
			raise ActiveRecord::Rollback, "Could not save! #{error}"
			error = ""
			render :new
		end
	end

	def edit
		@sale = Sale.find(params[:id])
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
		respond_to do |format|
			format.html
			format.csv { send_data @sales.to_csv1, filename: "weekly-#{Date.today}.csv" }
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
		respond_to do |format|
			format.html
			format.csv { send_data @sales.to_csv1, filename: "monthly-#{Date.today}.csv" }
		end

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

	def destroy
		@sale = Sale.find(params[:id])
		@sale.delete

		redirect_to root_path
    end

	private

	def set_sale
    	@sales = Sale.find(params[:id])
    end

	def sale_items_params
		params.permit(:product_id, :quantity)
	end

    def sale_params
    	params.require(:sale).permit(:saleTime)
    end
end
