# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'sinatra/json'

# XSS
helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect to('/memos')
end

def build_json_data
  Dir.glob('storage/*').sort.map { |file| JSON.parse(File.read(file)) }
end

get '/memos' do
  @memos = build_json_data
  erb :index
end

get '/new' do
  erb :new
end

post '/memos' do
  params[:id] = Time.now.strftime('%Y%m%d_%H%M%S')
  data_hash = { id: params[:id], title: params[:title], content: params[:content] }
  File.open("storage/#{Time.now.strftime('%Y%m%d_%H%M%S')}.json", 'w') { |file| file.puts JSON.generate(data_hash) }
  redirect to('/memos')
end

def file_path
  "storage/#{File.basename(params[:id])}.json"
end

get '/memos/:id' do
  @memo = JSON.parse(File.read(file_path), symbolize_names: true)
  erb :show
end

get '/memos/:id/edit' do
  @memo = JSON.parse(File.read(file_path), symbolize_names: true)
  erb :edit
end

patch '/memos/:id' do
  File.open(file_path, 'w') do |file|
    data_hash = { id: params[:id], title: params[:title], content: params[:content] }
    JSON.dump(data_hash, file)
  end
  redirect to("/memos/#{params[:id]}")
end

delete '/memos/:id' do
  File.delete(file_path)
  redirect to('/memos')
end

not_found do
  erb :not_found
end
