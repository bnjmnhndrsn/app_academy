# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

25.times do
  User.create!(name: Faker::Name.name)
end

User.where("users.id < 11").each do |user|
  user.authored_polls.create!(title: Faker::Hacker.say_something_smart)
end

Poll.all.each do |poll|
  4.times do
    poll.questions.create!(text: Faker::Lorem.words(5).join(" "))
  end
end

Question.all.each do |question|
  4.times do |i|
    question.answer_choices.create!(text: "#{i}: #{Faker::Lorem.words(1).first}" )
  end
end

User.where("users.id > 10 AND users.id < 21").each do |user|
  Poll.all.each do |poll|
    poll.questions.each do |question|
      question.answer_choices.first.responses.create!(respondent_id: user.id)
    end
  end
end

