require_relative 'post.rb'

class Generator
	def initialize(week, dest = nil)
		@destination = dest ? dest : "../weekly-reports/_posts/"
		@week = week
	end
	
	def write_post(post)
			target = File.open(@destination + generate_filename(post), 'w')
			target.write generate_text(post)
			target.close
	end
	
	# :private
	def generate_filename(post)
		"#{post.date.to_s}-#{@week}-#{post.title}.markdown"
	end
	
	def generate_text(post)
		"---\n" +
		"title:  #{post.title}\n" +
		"date:   #{post.date}\n" +
		"categories: #{post.categories.join(' ')}\n"+
		"---\n" +
		"#{post.content}\n"
	end
end

## intended usage
#g = Generator.new("../weekly-reports/_posts/", "week19")
#p = Post.new("test", ["test", "foo", "bar"], "##Test thingy")
#puts g, p, g.generate_filename(p), g.generate_text(p)

#g.write_post p
