require 'git'
require_relative 'log-reader.rb'

class GitLogReader < LogReader

	def read_log(date, path, options = {})
		#opening the repository
		repo = Git.open path
		
		#doing a fetch; might require credentials for the remote
		repo.fetch
		
		# getting the commits
		commits = repo.log.since("#{date}").author("#{@author}")
		
		text = ''
		commits.each do |commit|
			#Commit hash as headline
			headline = "\n#####Git commit: #{commit.sha}\n"
			puts headline
			text.concat headline
			
			# getting the issue information
			#TODO: link issue to Gitlab 
			issue = commit.message.split.select { |s| s.start_with? '#' }.first
			puts issue
			text.concat "Issue #{issue} - #{commit.name} \n\n"
			
			# adding the rest of the message
			text.concat commit.message.gsub('#', '\\#')
		end
		
		text
 	end
end