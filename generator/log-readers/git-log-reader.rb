class GitLogReader
 
	def read_commits(commits)
		text = ''
		commits.each do |commit|
			# getting the remote url for origin to construct an issue link
			url = commit['url'].split('commit')[0]
			
			#Commit hash as headline
			commit_url = commit['url']
			headline = "\n#####Git commit: [#{commit['id']}](#{commit_url})\n"
			puts headline
			text.concat headline
				
			# getting the issue information
			issue = commit['message'].split.select { |s| s.start_with? '#' }.first
			issue_url = url.concat "/issues/#{issue.gsub('#', '')}"
			text.concat "[Issue #{issue}](#{issue_url}) \n\n"
				
			# adding the rest of the message
			text.concat commit['message'].gsub('#', '\\#')
			text.concat " \n"
		end		
		text
	end 
end