class Movie < ActiveRecord::Base
  def self.ratings
    #['G','PG','PG-13','R']
    ratings = []
    select(:rating).order(:rating).uniq.each do |movie|
      if not ratings.include? movie.rating
        ratings.push(movie.rating)
      end
    end
    ratings
  end
end
