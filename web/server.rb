require 'sinatra'
require 'json'
require 'fileutils'
require_relative '../generator/log-readers/git-log-reader.rb'
require_relative '../generator/weekly.rb'
require 'sinatra/reloader' if development?

set :public_folder, File.dirname(__FILE__) + '/../weekly-reports/_site'

# create a real hash from yaml hash
conf = {	
		:posts_directory => File.dirname(__FILE__) + '/../weekly-reports/_posts/',
		}

get '/' do
	send_file File.expand_path('index.html', settings.public_folder)
end

post '/gitlab/push' do
	params = JSON.parse(request.env["rack.input"].read)
	File.open(File.dirname(__FILE__) + "hooklog.txt", 'a') do |file|
		file.write params
	end 
	
	if params['object_kind'] == 'push' && params['ref'] == "refs/heads/master"
		commits = params['commits'].select do |c|
			c['message'].match /Merge branch .+ into 'master'/
		end
		
		# building the posts for the merged commits
		weekly = Weekly.new(commits[0]['timestamp'], conf, commits)
		weekly.read_log(params['repository'], GitLogReader.new)
		
		# creating an index file for the project if none exists
		filename = "weekly-reports/projects/#{params['repository']['name']}.html"
		unless File.exist? filename
			file = File.read("weekly-reports/projects/sample.html").gsub('sample', params['repository']['name'])
			File.write("weekly-reports/projects/#{params['repository']['name']}.html", file)
		end
		
		# instructing jekyll to rebuild the site
		`jekyll build -s weekly-reports -d weekly-reports/_site`
	end
end
