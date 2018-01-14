class MoviesController < ApplicationController

  def movieParams
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if (!params[:ratings].nil?)
       Movie.checked_ratings = params[:ratings].keys
    end
     @ratingCheck = Movie.checked_ratings
     @showMovies = Movie.where({ rating: @ratingCheck})
    if (params[:sort] == "movie")
      @movies = @showMovies.order(:title)
    elsif (params[:sort] == "release")
      @movies = @showMovies.order(:release_date)
    else
      @movies = @showMovies
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[movieParams])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movieParams)
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