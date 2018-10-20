# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
User.create(name: "Adam", email: "admin@example.com", password: "12345678", role: "admin")
puts "admin created"

Category.destroy_all

category_list = [
  { name: "insects" },
  { name: "plants" },
  { name: "mammals" },
  { name: "birds" },
  { name: "fish" },
  { name: "reptiles" },
  { name: "amphibians" },
  { name: "arthropods" }
]

category_list.each do |category|
  Category.create( name: category[:name])
end

puts "Categories created."

