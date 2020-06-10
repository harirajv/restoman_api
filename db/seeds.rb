# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Dish.create!([
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

User.create!([
  {
    name: 'admin_user',
    role: 'admin',
    email: 'admin@resto.com',
    password: 'password',
    password_digest: BCrypt::Password.create('password')
  }
])
