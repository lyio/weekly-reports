require 'git'

class LogReader

	def initialize(author)
		@author = author
	end
end

class SvnLogReader < LogReader

	def read_log(date, path)
    	svn_cmd = "svn log #{path} -v -r{#{date}}:HEAD --search #{@author} | grep - > weekly"
    	puts svn_cmd 
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
				text.concat headline
			elsif l.start_with? 'Bug'
				bug = l.gsub(/(Bug )([0-9]+)/, "[" + '\0'+ "]" + "(#{@bugzilla_url}" + '\2' + ")").concat "\n"
				puts bug
				text.concat(bug)
			else
				puts l
				text.concat l
				end
			end
		text
	end

	:private
	def get_lines(file)
		lines = []
		file.each do |l|
			lines.push l if not l.start_with? '---' end
		file.close
		lines
	end
end

class GitLogReader < LogReader

	def read_log(date, path)
		""
	end
end
