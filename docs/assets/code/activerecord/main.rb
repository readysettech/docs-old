require 'pg'
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  url: ENV['DATABASE_URL']
)

class Basic < ActiveRecord::Base
  self.table_name = 'title_basics'
  self.primary_key = 'tconst'
end

class Rating < ActiveRecord::Base
  self.table_name = 'title_ratings'
  self.primary_key = 'tconst'
end

year = 1980
puts 'Year: %d' % [year]

Basic.find_by_sql(['SELECT title_basics.originaltitle, title_ratings.averagerating
  FROM title_basics
  JOIN title_ratings ON title_basics.tconst = title_ratings.tconst
  WHERE title_basics.startyear = ?
  AND title_basics.titletype = ?
  AND title_ratings.numvotes > ?
  ORDER BY title_ratings.averagerating DESC LIMIT 10',
  year, 'movie', 50000]).
  each { |r| puts "#{r.originaltitle},  #{r.averagerating}" }
  