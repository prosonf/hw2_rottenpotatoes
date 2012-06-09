class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    # Processing params to get search filters
    if params[:sort]
      @sortcol = params[:sort]
    end
    @rating_params = Hash.new
    if params[:ratings]
      @rating_params[:ratings] = params[:ratings]
      @rating_filters = params[:ratings].keys
      filters = {:rating => @rating_filters}
    elsif
      @rating_filters = Hash.new
    end

    # Session control. If no filters from request, maybe from session
    if not filters and not @sortcol and session[:params]
      redirect_to movies_path(session[:params])
    end

    # Search / load data for render
    @movies = Movie.where(filters).order(@sortcol)
    @all_ratings = Movie.ratings
    
    # Session control
    session[:params] = @rating_params.merge({:sort => @sortcol})
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
