class MoviesController < ApplicationController

  @@isTitleSorted = false
  @@isDateSorted = false
  @isSortedDate = false
  @isSortedTitle = false
  

  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
    logger.debug(params)
  end

  def index
    @all_ratings = Movie.individualRatings
    @collectedCheckBoxes = (session[:rating] ) ? session[:rating]: @all_ratings
    @movies = Movie.all
    @sessSort = (session[:isSorted]) ? session[:isSorted]: false
    logger.debug(session.to_hash)
    logger.debug("break")
    logger.debug(params.to_hash)
    
    if ( params[:ratings] || session[:ratingHash] )
      
      if (params[:ratings])
        @collectedCheckBoxes = params[:ratings].collect {|key,value| key }
        session[:ratingHash] = params[:ratings]
      elsif (session[:ratingHash])
        logger.debug(session[:ratingHash])
        logger.debug("-------------")
        @collectedCheckBoxes = session[:ratingHash].collect {|key,value| key }

      end
      @movies = Movie.with_ratings @collectedCheckBoxes
      if ( @@isTitleSorted)
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
      elsif ( @@isDateSorted)
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
        
      end

    end

    
    if (params[:titleSort] || (session[:sortHash]  && !@sessSort))
      if (params[:titleSort])
        sort = params[:titleSort]
        session[:sortHash] = params[:titleSort]
      elsif (session[:sortHash])
        sort = session[:sortHash]
        if (sort.to_s == '1')
          @@isTitleSorted = false;
        elsif (sort.to_s == '0')
          @@isDateSorted = false
        end
      end
      if ( sort.to_s == '1' && !@@isTitleSorted  )
        m = @movies
        mov = []
        m.each do |item|
          mov.push(item.title)
        end
        mov = mov.sort
        sortedMovies = []
        mov.each do |item| 
          m.each do |element| 
            if ( item == element.title && @collectedCheckBoxes.include?(element.rating))
              sortedMovies.push(element)
            end
          end
        end
        @movies = sortedMovies
        @@isTitleSorted = true
        session[:isSorted] = false
      elsif (sort.to_s == '1' && @@isTitleSorted )
        if (@@isDateSorted)
          m = @movies
          mov = []
          m.each do |item|
            mov.push(item.release_date)
          end
          mov = mov.sort
          sortedMovies = []
          mov.each do |item| 
            m.each do |element| 
              if ( item == element.release_date && @collectedCheckBoxes.include?(element.rating))
                sortedMovies.push(element)
              end
            end
          end
          @movies = sortedMovies
        else 
          m = Movie.all
          temp = []
          m.each do |element|
            if ( @collectedCheckBoxes.include?(element.rating) )
              temp.push(element)
            end
          end
          @movies = temp
        end
        @@isTitleSorted = false
        session[:isSorted] = true
      elsif (sort.to_s == '0' && !@@isDateSorted)
        m = @movies
        mov = []
        m.each do |item|
          mov.push(item.release_date)
        end
        mov = mov.sort
        sortedMovies = []
        mov.each do |item| 
          m.each do |element| 
            if ( item == element.release_date && @collectedCheckBoxes.include?(element.rating))
              sortedMovies.push(element)
            end
          end
        end
        @movies = sortedMovies
        @@isDateSorted = true
        session[:isSorted] = false
      elsif (sort.to_s == '0' && @@isDateSorted )
        if ( @@isTitleSorted)
          m = @movies
          mov = []
          m.each do |item|
            mov.push(item.title)
          end
          mov = mov.sort
          sortedMovies = []
          mov.each do |item| 
            m.each do |element| 
              if ( item == element.title && @collectedCheckBoxes.include?(element.rating))
                sortedMovies.push(element)
              end
            end
          end
          @movies = sortedMovies
        else
          m = Movie.all
          temp = []
          m.each do |element|
            if ( @collectedCheckBoxes.include?(element.rating) )
              temp.push(element)
            end
          end
          @movies = temp
        end
        @@isDateSorted = false
        session[:isSorted] = true
      end
    end
    
    @isSortedTitle = @@isTitleSorted
    @isSortedDate = @@isDateSorted
    
    session[:rating] = @collectedCheckBoxes

    
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
