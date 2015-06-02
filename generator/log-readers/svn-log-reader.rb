require_relative 'log-reader.rb'

class SvnLogReader < LogReader
	
	def read_log(date, path, options = {}) 	
		search = "--search #{@author}" if @author
		svn_cmd = "svn log #{path} -v -r{#{date}}:HEAD #{search} | grep - > weekly"
    	puts svn_cmd 
    	r = %x[#{svn_cmd}]

		lines = get_lines(File.open('weekly'))
		
		text = ''
		lines.each do |l|
			r = is_revision? l
			if r
				# revision as headline
				headline = "\n#####SVN Revision: #{l.split('|')[0]}\n"
				puts headline
				text.concat headline
			elsif l.start_with? 'Bug'
				bug = l.gsub(/(Bug )([0-9]+)/, "[" + '\0'+ "]" + "(#{options[:bugzilla_url]}" + '\2' + ")").concat "\n"
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
	
	def is_revision? (line)
		line.match(/(r[0-9]+)(.+)([0-9]+)/)
	end
end