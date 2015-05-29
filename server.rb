require 'pry'
require 'pg'
require 'sinatra'

def db_connect
  begin
    connection = PG.connect(dbname: "beer_reviews")
    yield connection
  ensure
    connection.close
  end
end

def beer_all
  results = db_connect do |conn|
    conn.exec("SELECT id, name FROM beers")
  end

  results.to_a
end

def brewery_all
  results = db_connect do |conn|
    conn.exec("SELECT * FROM breweries")
  end

  results.to_a
end

def beer_save(input)
  data = [input[:name], input[:description], input[:brewery]]
  db_connect do |conn|
    sql_query = "INSERT INTO beers (name, description, brewery_id)
    VALUES ($1, $2, $3)"
    conn.exec_params(sql_query, data)
  end
end

def beer_find(id)
  results = db_connect do |conn|
    sql_query = "SELECT beers.*, breweries.name AS brewery_name FROM beers
    JOIN breweries ON beers.brewery_id = breweries.id
    WHERE beers.id = $1"
    conn.exec_params(sql_query, [id])
  end

  results.to_a.first
end

def review_where(beer_id)
  results = db_connect do |conn|
    sql_query = "SELECT * FROM reviews
    WHERE beer_id = $1"
    conn.exec_params(sql_query, [beer_id])
  end

  results.to_a
end

def review_save(input)
  data = [input[:body], input[:id]]
  db_connect do |conn|
    sql_query = "INSERT INTO reviews (body, beer_id)
    VALUES ($1, $2)"
    conn.exec_params(sql_query, data)
  end
end

get '/' do
  redirect '/beers'
end

get '/beers' do
  @beers = beer_all
  erb :'beers/index'
end

get '/beers/new' do
  @breweries = brewery_all
  erb :'beers/new'
end

post '/beers' do
  beer_save(params)
  redirect '/beers'
end

get '/beers/:id' do
  @beer = beer_find(params[:id])
  @reviews = review_where(params[:id])
  erb :'beers/show'
end

post '/beers/:id/reviews' do
  review_save(params)
  redirect "/beers/#{params[:id]}"
end
