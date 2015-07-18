require 'sinatra'
require 'json'

set :public_folder, File.dirname(__FILE__) + '/../weekly-reports/_site'
set :port, 4000
set :bind, '0.0.0.0'

get '/' do
	send_file File.expand_path('index.html', settings.public_folder)
end

post '/gitlab' do
	params = JSON.parse(request.env["rack.input"].read)
	params.each do |p|
		$stdout.puts p
	end
	"received hook: #{params['object_attributes']['target']['name']}"
end
