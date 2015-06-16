require 'git'
require_relative 'log-reader.rb'

class GitLogReader < LogReader

	def read_log(date, path, options = {})
		#opening the repository
		repo = Git.open path
		
		#doing a fetch; might require credentials for the remote
		repo.fetch
		
		# getting the commits
		commits = @author ? repo.log.since("#{date}").author("#{@author}") : repo.log.since("#{date}")
		
		text = ''
		commits.each do |commit|
			# getting the remote url for origin to construct an issue link
			url = repo.remotes.select { |r| r.name == 'origin' }.first.url.gsub('.git', '')
			
			#Commit hash as headline
			commit_url = url + "/commit/#{commit.sha})"
			headline = "\n#####Git commit: [#{commit.sha}](#{commit_url}\n"
			puts headline
			text.concat headline
			
			# getting the issue information
			issue = commit.message.split.select { |s| s.start_with? '#' }.first
			puts issue
			issue_url = url.concat "/issues/#{issue.gsub('#', '')}"
			text.concat "[Issue #{issue}](#{issue_url}) - #{commit.name} \n\n"
			
			# adding the rest of the message
			text.concat commit.message.gsub('#', '\\#')
			text.concat " \n"
		end
		
		text
 	end
end