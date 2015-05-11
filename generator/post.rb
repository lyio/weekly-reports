require 'date'

class Post
	attr_accessor :title, :categories, :content, :date, :author

	def initialize(title, categories, content, author)
		@title = title
		@categories = categories
		@content = content
		@date = Date.today
		@author = author
	end
end