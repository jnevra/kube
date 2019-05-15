# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

99.times do |n| name = Faker::Name.name
email = "gelaskaca-#{n+1}@abc.org"
password = "123123"
User.create!(name: gelaskaca,
email: gelaskaca@abc.org,
password: 123123,
password_confirmation: 123123,
activated: true,
activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do content = Faker::Lorem.sentence(5)
users.each { |user| user.microposts.create!(content: content) }
end