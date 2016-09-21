# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Article.find_or_create_by(tag: :'ch1-1') do |a|
  a.title = "Chapitre 1 - Première Partie"
  a.group = :hdli
  a.published = true
  # a.published_at = "11-09-2016"
end

Article.find_or_create_by(tag: :'ch1-2') do |a|
  a.title = "Chapitre 1 - Seconde Partie"
  a.group = :hdli
  a.published = true
  # a.published_at = "11-09-2016"
end

Article.find_or_create_by(tag: :'ch1-sources') do |a|
  a.title = "Chapitre 1 - Sources"
  a.group = :hdli
  a.published = true
  # a.published_at = "21-09-2016"
end

########

Article.find_or_create_by(tag: :ssem) do |a|
  a.title = "The Manchester Baby"
  a.group = :bdd
  a.published = true
  # a.published_at = "11-09-2016"
end
