# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'Clear tables'
ActiveRecord::Base.connection.execute("TRUNCATE TABLE countries RESTART IDENTITY;")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE event_player_scores RESTART IDENTITY;")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE event_players RESTART IDENTITY;")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE events RESTART IDENTITY;")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE participating_countries RESTART IDENTITY;")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE users RESTART IDENTITY;")

puts 'Countries'
Country.create([
                   {name: 'Albania'},
                   {name: 'Armenia'},
                   {name: 'Australia'},
                   {name: 'Austria'},
                   {name: 'Azerbaijan'},
                   {name: 'Belarus'},
                   {name: 'Belgium'},
                   {name: 'Croatia'},
                   {name: 'Cyprus'},
                   {name: 'Czech Republic'},
                   {name: 'Denmark'},
                   {name: 'Estonia'},
                   {name: 'FYR Macedonia'},
                   {name: 'Finland'},
                   {name: 'France'},
                   {name: 'Georgia'},
                   {name: 'Germany'},
                   {name: 'Greece'},
                   {name: 'Hungary'},
                   {name: 'Iceland'},
                   {name: 'Ireland'},
                   {name: 'Israel'},
                   {name: 'Italy'},
                   {name: 'Latvia'},
                   {name: 'Lithuania'},
                   {name: 'Malta'},
                   {name: 'Moldova'},
                   {name: 'Montenegro'},
                   {name: 'Norway'},
                   {name: 'Poland'},
                   {name: 'Portugal'},
                   {name: 'Romania'},
                   {name: 'Russia'},
                   {name: 'San Marino'},
                   {name: 'Serbia'},
                   {name: 'Slovenia'},
                   {name: 'Spain'},
                   {name: 'Sweden'},
                   {name: 'Switzerland'},
                   {name: 'The Netherlands'},
                   {name: 'Ukraine'},
                   {name: 'United Kingdom'},
               ])
puts 'Events'
Event.create([
                 {
                     year: 2010,
                     country_id: Country.find_by(name: 'Sweden').id,
                     host_city: 'Oslo',
                     active: false,
                     real_winner_id: Country.find_by(name: 'Germany').id,
                     real_player_name: 'Onge',
                     home_winner_id: Country.find_by(name: 'Georgia').id,
                     home_player_name: 'Helen',
                 },
                 {
                     year: 2011,
                     country_id: Country.find_by(name: 'Germany').id,
                     host_city: 'Düsseldorf',
                     active: false,
                     real_winner_id: Country.find_by(name: 'Azerbaijan').id,
                     real_player_name: 'Joe',
                     home_winner_id: Country.find_by(name: 'Moldova').id,
                     home_player_name: 'Joanne',
                 },
                 {
                     year: 2012,
                     country_id: Country.find_by(name: 'Azerbaijan').id,
                     host_city: 'Baku',
                     active: false,
                     real_winner_id: Country.find_by(name: 'Sweden').id,
                     real_player_name: 'Ros',
                     home_winner_id: Country.find_by(name: 'Italy').id,
                     home_player_name: 'Onge',
                 },
                 {
                     year: 2013,
                     country_id: Country.find_by(name: 'Sweden').id,
                     host_city: 'Malmo',
                     active: false,
                     real_winner_id: Country.find_by(name: 'Denmark').id,
                     real_player_name: 'Joanne',
                 },
                 {
                     year: 2014,
                     country_id: Country.find_by(name: 'Denmark').id,
                     host_city: 'Copenhagen',
                     active: false,
                     real_winner_id: Country.find_by(name: 'Austria').id,
                     real_player_name: 'Joe',
                     home_winner_id: Country.find_by(name: 'Denmark').id,
                     home_player_name: 'Ros',
                     home_score: 58,
                     actual_uk_score: 40
                 },
             ])