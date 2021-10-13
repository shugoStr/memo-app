require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require "sinatra/json"
require 'tmpdir'

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
  json = Dir.glob('storage/*').sort_by { |file| File.birthtime(file) }
  @memos = json.map { |file| JSON.parse(File.read(file)) }
  erb :index
end

post '/memos' do
  hash = { id: params[:id] = '1', title: params[:title], content: params[:content] }
  File.open("storage/#{Time.now.strftime('%Y%m%d_%H:%M:%S')}.json", 'w') { |file| file.puts JSON.generate(hash) }
  redirect to('/memos')
end

get '/new' do
  erb :new
end

# def find_id(memo[:id])
#   # フォルダにファイルある？
#   if Dir.empty?(/storage)
#     # →ないなら、1セット
#     memo[:id] = '1'
#   else
#     files = Dir.glob('memos/*').sort_by { |file| File.id(file) }
#     # あるなら、ファイルソートして、最後のidをセット
#     # last_idの次の値をセットする
#     # sequence = 1.step
#     # sequence.next #=> 1
#   end
# end


not_found do
  "MIU 404 NOT FOUND."
end
