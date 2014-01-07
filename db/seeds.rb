# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
owner = Owner.new(email: 'ilya.blan4@gmail.com', approved: true)
owner.password = 'qwerty'
owner.password_confirmation = 'qwerty'
owner.save