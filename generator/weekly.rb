require 'date'
class Weekly

def initialize
	@pattern = /(r[0-9]+)(.+)([0-9]+)/
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
	target_path = "reports/week#{Date.parse("Sunday").strftime("%U")}_weekly_report_#{project_name}.md"
	@revisions = find_revisions(target_path)
	
	date = Date.parse("Sunday").strftime("%Y-%m-%d")
	svn_cmd = "svn log #{path_to_repo} -v -r{#{date}}:HEAD --search t.fiedler | grep - > weekly"

	r = %x[#{svn_cmd}]

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
				puts "##" + l
				target.write '##' + l
			elsif l.start_with? 'Bug'
					puts l + "\n"
					target.write l + "\n"
			else 
					puts l
					target.write l
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
end

repos = ['/cygdrive/c/Users/t.fiedler/VacationPlanner/', '/cygdrive/d/IntranetOfficeModules']
weekly = Weekly.new

repos.each do |repo| weekly.read_log(repo) end




