require 'date'

class Post
	attr_accessor :title, :categories, :content, :date

	def initialize(title, categories, content)
		@title = title
		@categories = categories
		@content = content
		@date = Date.today
	end
end