require_relative 'post.rb'

class Generator
	def initialize(week, dest = nil)
		@destination = dest ? dest : "../weekly-reports/_posts/"
		@week = week
	end
	
	def write_post(post)
			file_name = @destination + generate_filename(post)
			target = File.open(file_name, 'w')
			target.write generate_text(post)
			target.close
			
			file_name
	end
	
	:private
	def generate_filename(post)
		"#{post.date.to_s}-#{@week}-#{post.title}.markdown"
	end
	
	def generate_text(post)
		"---\n" +
		"title:  #{post.title}\n" +
		"date:   #{post.date}\n" +
		"categories: #{@week}\n"+
		"---\n" +
		"#{post.content}\n"
	end
end

## intended usage
#g = Generator.new("../weekly-reports/_posts/", "week19")
#p = Post.new("test", ["test", "foo", "bar"], "##Test thingy")
#puts g, p, g.generate_filename(p), g.generate_text(p)

#g.write_post p
