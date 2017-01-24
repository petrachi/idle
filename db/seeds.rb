# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Article.find_or_create_by(tag: :'ch1') do |a|
  a.title = "Chapitre 1 - Lecture"
  a.group = :hdli
  a.published = true
  a.published_at = "11-09-2016"
end

Article.find_or_create_by(tag: :'ch1-sources') do |a|
  a.title = "Chapitre 1 - Sources"
  a.group = :hdli
  a.published = true
  a.published_at = "21-09-2016"
end

########

Article.find_or_create_by(tag: :ssem) do |a|
  a.title = "The Manchester Baby"
  a.group = :bdd
  a.published = true
  a.published_at = "11-09-2016"
end

Article.find_or_create_by(tag: :complex_engine) do |a|
  a.title = "Complex Engine"
  a.group = :bdd
  a.published = true
  a.published_at = "12-10-2016"
end

Article.find_or_create_by(tag: :mult_engine) do |a|
  a.title = "Forme & Multiplication"
  a.group = :bdd
  a.published = false
  # a.published_at = "12-01-2017"
end
