require 'date'
require 'yaml'
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
		
		@week = "week#{Date.parse('Sunday').strftime('%U')}"
		# initialize post
		projects = @repos.collect do |r| r.split('/').last end
		@post = Post.new(@week, projects, '')
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
		target_path = "reports/week#{@week}_weekly_report_#{project_name}.md"
		@revisions = find_revisions(target_path)
		
		date = Date.parse("Sunday").strftime("%Y-%m-%d")
		svn_cmd = "svn log #{path_to_repo} -v -r{#{date}}:HEAD --search #{@user} | grep - > weekly"
	
		r = %x[#{svn_cmd}]
	
		@post.content.concat "##{project_name}\n\n"
		target = File.open(target_path, 'a')
		lines = get_lines(File.open('weekly'))
		rem = 0
		any_change = false
		while rem < lines.length
			l = lines[rem]
			r = is_revision? l
			skip = check_revision l
			if skip == 0
				puts "skipping #{skip}"
				if r
					# revision as headline
					headline = "## #{l}" 
					puts headline
					target.write headline
					@post.content.concat(headline)
				elsif l.start_with? 'Bug'
						puts l + "\n"
						target.write l + "\n"
						@post.content.concat(l+"\n")
				else 
						puts l
						target.write l
						@post.content.concat l
				end
				rem += 1
				any_change = true
			else 
				rem += skip
			end
		end
			 
		target.write "\n----------\n" if any_change
		target.close
	end

	def write_post
		g = Generator.new(@week)
		g.write_post @post
	end 
end

weekly = Weekly.new

puts "processing svn repos:", weekly.repos
weekly.repos.each do |repo| weekly.read_log(repo) end

#generate the jekyll post files
weekly.write_post





