require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'json'


get '/' do
  redirect to('/memos')
end

get '/memos' do
  erb :index
end

get '/new' do
  erb :new
end

get '/crate' do
  redirect to('/memos')
end

not_found do
  "ops! the requested information wasn't available."
end
