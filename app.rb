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
  sql_insert = "INSERT INTO memos (title, content) VALUES ('#{params[:title]}','#{params[:content]}')"
  connect.exec(sql_insert)
  redirect to('/memos')
end

get '/memos/:id' do
  sql_select_id = "SELECT * FROM memos WHERE id = '#{params[:id]}'"
  @memo = connect.exec(sql_select_id)
  erb :show
end

get '/memos/:id/edit' do
  sql_edit = "SELECT * FROM memos WHERE id = '#{params[:id]}'"
  @memo = connect.exec(sql_edit)
  erb :edit
end

def sql_setting(id, title, content)
  "UPDATE memos SET title = '#{title}', content = '#{content}' WHERE id = '#{id}'"
end

patch '/memos/:id' do
  sql_update = sql_setting(params[:id], params[:title], params[:content])
  connect.exec(sql_update)
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  sql_delete = "DELETE FROM memos WHERE id = '#{params[:id]}'"
  connect.exec(sql_delete)
  redirect to('/memos')
end

not_found do
  erb :not_found
end
