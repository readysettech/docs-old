#!ruby

require 'pg'

def query(conn)
  puts '------------------------------------------------'

  year = 1980
  puts 'Year: %d' % [year]

  res = conn.exec('SELECT title_basics.originaltitle, title_ratings.averagerating
                   FROM title_basics
                   JOIN title_ratings ON title_basics.tconst = title_ratings.tconst
                   WHERE title_basics.startyear = $1
                   AND title_basics.titletype = $2
                   AND title_ratings.numvotes > $3
                   ORDER BY title_ratings.averagerating DESC LIMIT 10',
                   [year, 'movie', 50000])

  res.each do |val|
    puts val
  end                   
end

def main()
  conn = PG.connect(ENV['DATABASE_URL'])

  query(conn)

  conn.close()
end

main()
