class MoviesController < ApplicationController
  
  @@notSorted = true
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if ( @@notSorted  )
      request.headers
      @movies = Movie.all
      @@notSorted = false
    else
      sort = params[:titleSort]
      @movies = Movie.all
      # @movies[0].title = @movies[0].title + sort.class
      if (sort.to_s == '1') 
        m = Movie.all
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
        @@notSorted = true
      elsif (sort.to_s == '0')
        m = Movie.all
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
        @@notSorted = true
      end
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
