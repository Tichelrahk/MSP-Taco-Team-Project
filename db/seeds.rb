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
product3 = Product.create( name: 'Lozenges', stock: 196, price: 600, active: true)
product1.save()
product2.save()
product3.save()

time1 = DateTime.now()
time2 = (time1 - 3.weeks)+ 5.minutes
time3 = (time2 - 5.weeks)

sale1 = Sale.create(saleTime: time1)
item1 = SaleItem.create(quantity:5)
item1.sale = sale1
item1.product = product1
item1.save()

item2 = SaleItem.create(quantity:10)
item2.sale = sale1
item2.product = product2
item2.save()

sleep(3)

sale2 = Sale.create(saleTime: time1)
item3 = SaleItem.create(quantity:10)
item3.sale = sale2
item3.product = product1
item3.save()

item4 = SaleItem.create(quantity:15)
item4.sale = sale2
item4.product = product2
item4.save()

sale3 = Sale.create(saleTime: time2)
item5 = SaleItem.create(quantity:50)
item5.sale = sale3
item5.product = product1
item5.save()

sale4 = Sale.create(saleTime: time3)
item6 = SaleItem.create(quantity: 2)
item6.sale = sale4
item6.product = product3
item6.save()
item7 = SaleItem.create(quantity: 1)
item7.sale = sale4
item7.product = product1
item7.save()

puts ("#{Sale.all.count}Sales Product#{item2.product.name}  Sale #{Sale.all.count} SaleItem #{SaleItem.all.count}")