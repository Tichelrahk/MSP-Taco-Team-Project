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

	#Needs Work
	def create	
		productID1 = params[:product_id1].to_i
		itemQuantity1 = params[:quantity1].to_i
		item1 = SaleItem.create(quantity: itemQuantity1)
		productID2 = params[:product_id2].to_i
		itemQuantity2 = params[:quantity2].to_i
		item2 = SaleItem.create(quantity: itemQuantity2)
		if Product.exists?(:id => productID1)			
			sale = Sale.create(saleTime: Time.now())
			item1.sale = sale
			item1.product = Product.find(productID1)
			item1.save
			if Product.exists?(:id => productID2)
				item2.sale = sale
				item2.product = Product.find(productID2)
				item2.save
			end
			if sale.save
			  redirect_to root_path
			else
			  render :new
			end	
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
