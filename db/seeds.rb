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

product1 = Product.create( name: 'Asprin', stock: 50, price: 500, active:true)
product2 = Product.create( name: 'Panadol', stock: 50, price: 800, active:true)
product1.save()
product2.save()

sale = Sale.create()
item1 = SaleItem.create(quantity:5)
item1.sale = sale
item1.product = product1
item1.save()

item2 = SaleItem.create(quantity:10)
item2.sale = sale
item2.product = product2
item2.save()

puts ("1 sale created Product#{item2.product.name}  Sale #{Sale.all.count} SaleItem #{SaleItem.all.count}")