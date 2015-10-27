require 'date'
require 'yaml'
require 'fileutils.rb'
require_relative 'post.rb'
require_relative 'post-generator.rb'
require_relative 'log-readers/git-log-reader.rb'

class Weekly

	def initialize(date, c, commits)
		@week = "week#{Date.parse(date).strftime('%U').to_i + 1}"
				
		@posts_directory = c[:posts_directory]
		
		@commits = commits
	end
	
	def read_log(repository, reader)
		project_name = repository['name']
		
		# initialize post
		@post = Post.new(@week,	 [], '', @user)
		
		target_path = "reports/#{project_name}/#{@week}.md"
	
		text = reader.read_commits(@commits)
		
		text.concat "\n"
		@post.content.concat text
		Dir.mkdir("reports/#{project_name}") unless File.exists?("reports/#{project_name}")
	
		# only write a file and add project to Jekyll post if there actually were commits that week
		unless text.length <= 1
			File.write(target_path, text)
			@post.categories.push project_name
			write_post
		end 
	end

	def write_post
		g = PostGenerator.new(@week, @posts_directory)
		puts "written post to: #{g.write_post @post}"
		
		# copy files over to dropbox for backup
		FileUtils.cp_r(@posts_directory, @dropbox) if @dropbox
	end 
end
