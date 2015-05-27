require 'date'
require 'yaml'
require 'fileutils.rb'
require_relative 'post.rb'
require_relative 'post-generator.rb'
require_relative 'log-reader.rb'

class Weekly

	def initialize(user, c)
		@pattern = /(r[0-9]+)(.+)([0-9]+)/
		
		# loading configuration
		@user = user	
		@week = "week#{Date.parse('Sunday').strftime('%U').to_i + 1}"
		puts @week
		
		# initialize post
		@post = Post.new(@week,	 [], '', @user)
		@dropbox = c[:dropbox]
		@posts_directory = c[:posts_directory]
		@bugzilla_url = c[:bugzilla]
	end
	
	def is_revision? (line)
		line.match(@pattern)
	end
	
	def read_log(path_to_repo, reader)
		project_name = path_to_repo.split('/').last
		target_path = "reports/#{@user}/#{@week}/#{project_name}.md"
	
		date = Date.parse("Sunday").strftime("%Y-%m-%d")
		
		text = reader.read_log(date, path_to_repo)
		
		text.concat "\n"
		@post.content.concat text
		Dir.mkdir("reports/#{@user}") unless File.exists?("reports/#{@user}")
		Dir.mkdir("reports/#{@user}/#{@week}") unless File.exists?("reports/#{@user}/#{@week}")
		
		# only write a file and add project to Jekyll post if there actually were commits that week
		unless text.length <= 1
			File.write(target_path, text)
			@post.categories.push project_name
		end 
	end

	def write_post
		g = PostGenerator.new(@week, @posts_directory)
		puts "written post to: #{g.write_post @post}"
		
		# copy files over to dropbox for backup
		FileUtils.cp_r(@posts_directory, @dropbox) if @dropbox
	end 
end


# loading in configuration file to get users and repos for each
c = YAML.load_file('../config.yaml')

# create a real hash from yaml hash
conf = {
		:dropbox => c['dropbox'],
		:posts_directory => c['posts_directory'],
		:bugzilla => c['bugzilla']
		}

# iterate over users in config
c['users'].each do |user| 
	svn_repos = c['repos']['svn']
	git_repos = c['repos']['git']
	
	weekly = Weekly.new(user, conf)
	puts "#{user} --> processing svn repos: ", svn_repos
	svn_reader = SvnLogReader.new user
	svn_repos.each do |repo| weekly.read_log(repo, svn_reader) end
	
	puts "#{user} --> processing git repos:", git_repos
	git_reader = GitLogReader.new user
	git_repos.each do |repo| weekly.read_log(repo, git_reader) end
end
	
#generate the jekyll post files
weekly.write_post if conf['users'] === 't.fiedler'
