# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

topics = Topic.create([
                        { label: 'Football' },
                        { label: 'Travel' },
                        { label: 'Politics' },
                        { label: 'Art' },
                        { label: 'Dating' },
                        { label: 'Music' },
                        { label: 'Movies' },
                        { label: 'Series' },
                        { label: 'Food' }
                      ])
if Rails.env.development?
  Admin.create!(email: 'admin@target.com',
                password: 'password',
                password_confirmation: 'password',
                name: 'Admin')
end
