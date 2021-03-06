# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

50.times do |n|
  name = Faker::Internet.user_name(2..10)
  password = "Password"
  User.create!(name: name, password: password, password_confirmation: password)
end

users = User.order(:created_at)
2.times do
  content = Faker::Overwatch.quote
  users.each do |user|
    user.posts.create!(content: content)
  end
end

users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each do |followed|
  user.follow(followed)
end
followers.each do |follower|
  follower.follow(user)
end
