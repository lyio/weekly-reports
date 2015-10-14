require_relative 'post.rb'

class PostGenerator
	def initialize(week, dest = nil)
		@destination = dest ? dest : "../weekly-reports/_posts/"
		@week = week
	end
	
	def write_post(post)
			$stdout.puts @destination
			
			Dir.mkdir @destination + "#{post.categories[0]}/" unless File.exist?(@destination + "#{post.categories[0]}/")
			file_name = @destination + "#{post.categories[0]}/" + generate_filename(post)
			target = File.open(file_name, 'a')
			target.write generate_text(post)
			target.close
			
			file_name
	end
	
	:private
	def generate_filename(post)
		"#{post.date.to_s}-#{post.title}-#{post.categories[0]}.markdown"
	end
	
	def generate_text(post)
		"---\n" +
		"author: #{post.author}\n" +
		"title:  #{post.title}\n" +
		"date:   #{post.date}\n" +
		"categories: #{post.categories}\n"+
		"projects: #{post.categories}\n" +
		"---\n" +
		"#{post.content}\n"
	end
end
