class Movie < ActiveRecord::Base

    
    def self.individualRatings
        return Movie.distinct.pluck(:rating)
    end
    
    def self.with_ratings diffRatings
        # where(id: [array of values])
        
        Movie.where(rating: diffRatings)
        
    end
end
