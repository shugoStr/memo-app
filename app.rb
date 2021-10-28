# frozen_string_literal: true

require "sinatra"
require "sinatra/reloader"
require "erb"
require "pg"

connect = PG.connect(dbname: "memo")

# XSS
helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get "/" do
  redirect to("/memos")
end

get "/memos" do
  @memos = connect.exec("SELECT * FROM memos;")
  erb :index
end

get "/new" do
  erb :new
end

post "/memos" do
  title = params[:title]
  content = params[:content]
  connect.exec("INSERT INTO memos (title, content) VALUES ($1, $2);", [title, content])
  redirect to("/memos")
end

get "/memos/:id" do
  erb :show
end

get "/memos/:id/edit" do
  erb :edit
end

patch "/memos/:id" do
  redirect to("/memos/#{params[:id]}")
end

delete "/memos/:id" do
  redirect to("/memos")
end

not_found do
  erb :not_found
end
