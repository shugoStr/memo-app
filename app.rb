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
