class MoviesController < ApplicationController
  before_filter :look_up_session
  @@sortedTitle = false;
  @@sortedDates = false;
  
  def look_up_session
  end
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.individualRatings
    @collectedCheckBoxes = session[:rating]
    @movies = Movie.all
    
    if ( params[:ratings] || session[:ratingHash])
      if (params[:ratings])
        @collectedCheckBoxes = params[:ratings].collect {|key,value| key }
      elsif (session[:ratingHash])
        @collectedCheckBoxes = session[:ratingHash].collect {|key,value| key }
      end
        
      @movies = Movie.with_ratings @collectedCheckBoxes
      session[:rating] = @collectedCheckBoxes
      session[:ratingHash] = params[:ratings]
    end
    if (params[:titleSort] || session[:sortHash])
      if (params[:titleSort])
        sort = params[:titleSort]
      elsif (session[:sortHash])
        sort = session[:sortHash]
        @@sortedTitle = false
      end
      if ( (sort.to_s == '1') && !@@sortedTitle ) 
        m = @movies
        mov = []
        m.each do |item|
          mov.push(item.title)
        end
        mov = mov.sort
        sortedMovies = []
        mov.each do |item| 
          m.each do |element| 
            if ( item == element.title)
              sortedMovies.push(element)
            end
          end
        end
        @movies = sortedMovies
        @@sortedTitle = true
        session[:sort] = '1'
      elsif(sort.to_s == '1' && @@sortedTitle)
        @@sortedTitle = false
        @movies = Movie.all
      elsif((sort.to_s == '0' && !@@sortedDates)  )
        m = @movies
        mov = []
        m.each do |item|
          mov.push(item.release_date)
        end
        mov = mov.sort
        sortedMovies = []
        mov.each do |item| 
          m.each do |element| 
            if ( item == element.release_date)
              sortedMovies.push(element)
            end
          end
        end
        @movies = sortedMovies
        @@sortedDates = true
        session[:sort] = '0'
      elsif (sort.to_s == '0' && @@sortedDates)
        @@sortedDates = false
        @movies = Movie.all  
      end
      session[:sortHash] = params[:titleSort]
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
