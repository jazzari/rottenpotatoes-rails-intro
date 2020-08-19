class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # select all type of ratings to create checkboxes in view
    @all_ratings = Movie.all_ratings
    if params[:ratings].nil?
      # all checkboxes checked the first time
      @ratings = @all_ratings
    else
    # collect user selected checkboxes
    @ratings = params[:ratings].keys
    end
    # hold selected checkboxes to remember user's selection
    @checked_boxes = @ratings

    # change background color of selected column
    if params[:order].in? %w[release_date]
      @sort = "release_date"
    else
      @sort = "title"
    end

    if params[:ratings].present?
      # sort movies from checkboxes
      @movies = Movie.with_ratings(@ratings)
    else
    # sort movies from title or release_date columnns
      @movies = Movie.sort_order(params[:order])
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
