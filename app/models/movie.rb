class Movie < ActiveRecord::Base

	def self.sort_order(column)
		@movies = Movie.all
		if column == "release_date"
			@movies.merge!(Movie.order("release_date ASC"))
		else
			@movies.merge!(Movie.order("title ASC"))
		end
	end

	def self.all_ratings
		@ratings = Movie.distinct.pluck("rating")
	end

	def self.with_ratings(ratings)
		@checked = ratings
		@ratings = Movie.where(rating: @checked)
	end

end
