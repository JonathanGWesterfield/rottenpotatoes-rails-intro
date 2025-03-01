# class MoviesController < ApplicationController
#
#   def movie_params
#     params.require(:movie).permit(:title, :rating, :description, :release_date)
#   end
#
#   def show
#     id = params[:id] # retrieve movie ID from URI route
#     @movie = Movie.find(id) # look up movie by unique ID
#     # will render app/views/movies/show.<extension> by default
#   end
#
#   def index
#     @movies = Movie.all
#   end
#
#   def new
#     # default: render 'new' template
#   end
#
#   def create
#     @movie = Movie.create!(movie_params)
#     flash[:notice] = "#{@movie.title} was successfully created."
#     redirect_to movies_path
#   end
#
#   def edit
#     @movie = Movie.find params[:id]
#   end
#
#   def update
#     @movie = Movie.find params[:id]
#     @movie.update_attributes!(movie_params)
#     flash[:notice] = "#{@movie.title} was successfully updated."
#     redirect_to movie_path(@movie)
#   end
#
#   def destroy
#     @movie = Movie.find(params[:id])
#     @movie.destroy
#     flash[:notice] = "Movie '#{@movie.title}' deleted."
#     redirect_to movies_path
#   end
#
# end

class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.order(:rating).select(:rating).map(&:rating).uniq
    @checked_ratings = check
    @checked_ratings.each do |rating|
      params[rating] = true
    end

    if params[:sort]
      @movies = Movie.order(params[:sort])
    else
      @movies = Movie.where(:rating => @checked_ratings)
    end
  end

  def new
    # default: render 'new' template
  end

  # Create function for the movie. For adding movies
  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  # Allows us to find the movie based on the movie id
  def edit
    @movie = Movie.find params[:id]
  end

  # Allows us to update a movie based on the movie id
  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  # Allows us to delete movies
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private

  def check
    if params[:ratings]
      params[:ratings].keys
    else
      @all_ratings
    end
  end

end