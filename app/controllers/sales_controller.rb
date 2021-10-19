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
			if quant <= product.stock
				product.stock = product.stock - quant
				si = SaleItem.new
				si.product = product
				si.quantity = quant
				si.sale = sale
				si.save()
				product.save()
			else
				error = "not enough stock"
				puts error
			end
		end
		if (error == "")

			if sale.save
				sale.sale_items.each do |si| 
					si.product.save
					puts " PRODUCT STOKK #{si.product.stock}"
					si.save
				end
				redirect_to root_path
			else
				raise ActiveRecord::Rollback, "Could not save! #{error}"
			end
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

	def prediction
		@products = Product.all
		#to keep flash message after redirect_to display flash message
		flash.keep
		#when search is done
		if params[:search]
			#entered id by user
			@search_term = params[:search]
			#sales from now to last month
			@saleitemsm1 = SaleItem.where(product_id: @search_term, created_at: (Time.now-1.month)..Time.now)
			#sales between 1 month ago to 2 months ago
			@saleitemsm2 = SaleItem.where(product_id: @search_term, created_at: (Time.now-2.month)..Time.now-1.month)
			
			#final predicted value initialised
			@predicted_value = 0
			if(SaleItem.where(product_id: @search_term).present?)

				# check if sale data 1 exists
				if @saleitemsm1.present?
					@saleitemsm1.each do |s|
						@predicted_value += s.quantity
					end
				end
				#check if sale data 2 exists
				if @saleitemsm2.present?
					@saleitemsm2.each do |s|
						@predicted_value += s.quantity
					end
					@predicted_value /=2
				end
				
				if(@predicted_value == 0)
					display = "There is not enough data to predict sales of this item."
				else
				display = "The next months prediction for the item with id #{@search_term} is #{@predicted_value} units."
				end
			else
				display = "There is no item in the database with that id."
			end
			redirect_to displayprediction_path, :flash => { :notice => display}
			
		end
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
