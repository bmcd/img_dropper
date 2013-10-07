# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(email: "bradmcdermott@gmail.com", password: 'password', password_confirmation: 'password')

User.create(email: "test1@gmail.com", password: 'password', password_confirmation: 'password')

User.create(email: "test2@gmail.com", password: 'password', password_confirmation: 'password')


8.times do
  Image.create(image_url: "http://placekitten.com/#{300 + rand(300)}/#{300 + rand(300)}/", user_id: rand(4))
end