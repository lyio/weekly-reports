require 'date'
require 'yaml'
require 'fileutils.rb'
require_relative 'post.rb'
require_relative 'file-generator.rb'

class Weekly
	attr_accessor :repos
	
	def initialize
		@pattern = /(r[0-9]+)(.+)([0-9]+)/
		
		# loading configuration
		c = YAML.load_file('../config.yaml')
		@user = c['user']
		@repos = c['repos'].split(' ')
		
		@week = "week#{Date.parse('Sunday').strftime('%U').to_i + 1}"
		puts @week
		# initialize post
		projects = @repos.collect do |r| r.split('/').last end
		puts "projects: #{projects}"
		@post = Post.new(@week, projects, '')
		@dropbox = c['dropbox']
		@posts_directory = c['posts_directory']
		@bugzilla_url = c['bugzilla']
	end
	
	def find_revisions(in_file)
		if not File.exist? in_file then return [] end
		file = File.open(in_file, 'r')
		revision_list = []
		file.each do |line|
			matches = is_revision? line
			# adding revision to list
			revision_list.push matches[1] if matches
		end
		file.close()
		revision_list
	end
	
	def is_revision? (line)
		line.match(@pattern)
	end
	
	def check_revision(line)
		r = is_revision? line 
		if r and @revisions.include? r[1]
			r[3].to_i
			else 0
		end
	end
	
	def get_lines(file)
		lines = []
		file.each do |l|
			lines.push l if not l.start_with? '---' end
		file.close
		lines
	end

	def read_log(path_to_repo)
		project_name = path_to_repo.split('/').last
		# getting past revisions
		target_path = "reports/#{@week}/#{project_name}.md"
	
		date = Date.parse("Sunday").strftime("%Y-%m-%d")
		svn_cmd = "svn log #{path_to_repo} -v -r{#{date}}:HEAD --search #{@user} | grep - > weekly"
	
		r = %x[#{svn_cmd}]
		
		lines = get_lines(File.open('weekly'))
		@post.content.concat "##{project_name}\n" unless lines.empty?
		text = ''
		lines.each do |l|
			r = is_revision? l
			if r
				# revision as headline
				headline = "\n#####SVN Revision: #{l.split('|')[0]}\n" 
				puts headline
				text.concat(headline)
			elsif l.start_with? 'Bug'
				bug = l.gsub(/(Bug )([0-9]+)/, "[" + '\0'+ "]" + "(#{@bugzilla_url}" + '\2' + ")").concat "\n"		
				puts bug	
				text.concat(bug)
			else 
				puts l
				text.concat l
				end
			end	 
		
		text.concat "\n"
		@post.content.concat text
		Dir.mkdir("reports/#{@week}") unless File.exists?("reports/#{@week}")
		File.write(target_path, text)
	end

	def write_post
		g = Generator.new(@week, @posts_directory)
		puts "written post to: #{g.write_post @post}"
		
		# copy files over to dropbox for backup
		FileUtils.cp_r(@posts_directory, @dropbox)
	end 
end

weekly = Weekly.new

puts "processing svn repos:", weekly.repos
weekly.repos.each do |repo| weekly.read_log(repo) end

#generate the jekyll post files
weekly.write_post





