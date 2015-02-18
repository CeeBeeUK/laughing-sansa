# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'Clear tables'
ActiveRecord::Base.connection.execute("TRUNCATE TABLE Countries RESTART IDENTITY;")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE Events RESTART IDENTITY;")

puts 'Countries'
Country.create([
                   {name: 'Albania'},
                   {name: 'Armenia'},
                   {name: 'Austria'},
                   {name: 'Azerbaijan'},
                   {name: 'Belarus'},
                   {name: 'Belgium'},
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
                     active: false
                 },
                 {
                     year: 2011,
                     country_id: Country.find_by(name: 'Germany').id,
                     host_city: 'Düsseldorf',
                     active: false
                 },
                 {
                     year: 2012,
                     country_id: Country.find_by(name: 'Azerbaijan').id,
                     host_city: 'Baku',
                     active: false
                 },
                 {
                     year: 2013,
                     country_id: Country.find_by(name: 'Sweden').id,
                     host_city: 'Malm',
                     active: false
                 },
                 {
                     year: 2014,
                     country_id: Country.find_by(name: 'Denmark').id,
                     host_city: 'Copenhagen',
                     active: false
                 },
             ])