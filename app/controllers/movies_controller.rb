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
    # first time visiting index page
    if params[:ratings].nil? && params[:order].nil? 
      @ratings = session[:ratings]
      session[:ratings] ||= @all_ratings
      @movies = Movie.with_ratings(session[:ratings]) 
    else
      if params[:order].nil? && params[:ratings].any?
        # the user select checkboxes to filter the view
        session[:ratings] = params[:ratings].keys
        @ratings = session[:ratings]
        @movies = Movie.with_ratings(session[:ratings])
      elsif !params[:ratings].nil?
        # all rating checkboxes selected
        @movies = Movie.with_ratings(session[:ratings])
        logger.debug "session for all ratings: #{session[:ratings]}"
      else
        # the user filter for columns (title, or release_date)
        @rat_movies = Movie.with_ratings(session[:ratings])
        @movies = @rat_movies.sort_order(params[:order])
        @ratings = session[:ratings]
        logger.debug "session for order: #{session[:ratings]}"
      end   
    end
    #logger.debug "final session: #{session[:ratings]}"
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


