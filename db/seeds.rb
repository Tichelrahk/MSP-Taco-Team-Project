# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Product.destroy_all
Sale.destroy_all
SaleItem.destroy_all

product = Product.create( name: 'Asprin', stock: 50, price: 500, active:true)
sale = Sale.create()
item = SaleItem.create(quantity:5)
item.sale = sale
item.product = product

puts ("1 sale created #{product.name} #{Sale.all.count}")