class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
  
    @all_ratings  = Movie.ratings
    @redirect     = false
    @ratings      = params[:ratings]
    @sort         = params[:sort]
    
    if not @ratings.nil? then
      if @ratings.is_a?(Hash) then
        @ratings = @ratings.keys
      end
      session[:ratings] = @ratings
    else
      @ratings = []
      if not session[:ratings].nil? then
        @ratings = session[:ratings]
        @redirect = true
      end
    end
    
    if @sort.nil? then
      if not session[:sort].nil? then
        @redirect = true
        @sort = session[:sort]
      end
    else
      session[:sort] = @sort
    end
    
    if @redirect then
      redirect_to :action=> "index", :ratings => @ratings, :sort => @sort
    end
    
    case @sort
      when "title"
        if not @ratings.empty? then
          @movies = Movie.find_all_by_rating(@ratings, :order => "title")
        else
          @movies = Movie.all(:order => "title")
        end
        @hiliteA = "hilite"
        @hiliteB = ""
      when "release_date"
        if not @ratings.empty? then
          @movies = Movie.find_all_by_rating(@ratings, :order => "release_date")
        else
          @movies = Movie.all(:order => "release_date")
        end
        @hiliteA = ""
        @hiliteB = "hilite"
      else
        if not @ratings.empty? then
          @movies = Movie.find_all_by_rating(@ratings)
        else
          @movies = Movie.all
        end
        @hiliteA = ""
        @hiliteB = ""
    end  
    
    
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
