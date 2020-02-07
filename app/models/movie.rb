class Movie < ActiveRecord::Base

    
    def self.individualRatings
        return Movie.distinct.pluck(:rating)
    end
    
    def self.with_ratings diffRatings
        Movie.where(rating: diffRatings)
    end
    
    def self.sort_diff isTitle
        if (isTitle )
            Movie.order(:title)
        elsif (!isTitle)
            Movie.order(:release_date)
        end
        
    end
end
