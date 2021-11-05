# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'pg'

connect = PG.connect(dbname: 'memo')

# XSS
helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect to('/memos')
end

get '/memos' do
  sql_select = 'SELECT * FROM memos'
  @memos = connect.exec(sql_select)
  erb :index
end

get '/new' do
  erb :new
end

post '/memos' do
  connect.exec('INSERT INTO memos (title, content) VALUES ($1, $2)', ["#{params[:title]}", "#{params[:content]}"])
  redirect to('/memos')
end

get '/memos/:id' do
  @memo = connect.exec('SELECT * FROM memos WHERE id = $1', ["#{params[:id]}"])
  erb :show
end

get '/memos/:id/edit' do
  @memo = connect.exec('SELECT * FROM memos WHERE id = $1', ["#{params[:id]}"])
  erb :edit
end

patch '/memos/:id' do
  connect.exec('UPDATE memos SET title = $1, content = $2 WHERE id = $3', ["#{params[:title]}", "#{params[:content]}","#{params[:id]}"])
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  connect.exec('DELETE FROM memos WHERE id = $1', ["#{params[:id]}"])
  redirect to('/memos')
end

not_found do
  erb :not_found
end
