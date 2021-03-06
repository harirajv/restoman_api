# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Account.create!(
  {
    name: 'Dream Restaurant',
    subdomain: 'localhost'
  }
)

Account.first.dishes.create!([
  {
    name: 'Idli',
    description: 'South Indian steamed cake of rice served with sambhar',
    cost: 24.99,
    image: 'https://image.shutterstock.com/image-photo/indian-idly-chutney-sambar-600w-1171507429.jpg'
  },
  {
    name: 'Masala Dosa',
    description: 'Dosa stuffed with spiced potato filling',
    cost: '39.99',
    image: 'https://image.shutterstock.com/image-photo/masala-dosa-south-indian-meal-600w-1008673576.jpg'
  }
])

Account.first.users.create!([
  {
    name: 'admin',
    role: 'admin',
    email: 'admin@email.com',
    password: 'admin123',
    password_confirmation: 'admin123'
  }
])

Account.first.orders.create!([
  {
    table_no: 1,
    user_id: User.first.id
  }
])

Account.first.orders.first.order_items.create!([
  {
    dish_id: Dish.first.id,
    order_id: Order.first.id,
    quantity: 5
  }
])

Account.first.orders.first.create_bill!(
  {
    order_id: Order.first.id,
    cost: 150,
    payment_mode: 0
  }
)
