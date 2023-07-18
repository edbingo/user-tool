# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Generate a bunch of universities.
University.create!(name: "ETH Zürich")
University.create!(name: "Uni Zürich")
University.create!(name: "ZHAW")
University.create!(name: "ZHdK")

# Create a main sample user.
User.create!(name: "Edward Lancaster", email: "test@test.com", password: "password", password_confirmation: "password", role: 3, university_id: 3)

# Generate a bunch of regular users.
User.create!(name: "Max Muster", email: "max@example.com", password: "password", password_confirmation: "password", paid: false, university_id: 1)
User.create!(name: "John Doe", email: "john@example.com", password: "password", password_confirmation: "password", paid: true, university_id: 2)
User.create!(name: "Jane Doe", email: "jane@example.com", password: "password", password_confirmation: "password", paid: false, university_id: 1)
