class MoviesController < ApplicationController

  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
 
  def index
   @all_ratings = Movie.all_ratings
   @ratings_to_show = []
   #puts @ratings_to_show

  
   if session[:'ratings'] != nil
     if params[:'ratings'] == nil
       if params[:commit] == nil and session[:ratings].empty? != true
        params[:'ratings'] = session['ratings']
        
        session[:ratings]={}
       end
     end
   end
   
    if session[:'sortVar'] != nil
     if params[:'sortVar'] == nil
       
        params[:'sortVar'] = session['sortVar']
        
        session[:sortVar]={}
      
     end
    end
     
   
   @sortVariable = params[:sortVar]
   
   #puts params
   #puts 'seperating comment'
   #puts session
   
    if params[:'ratings'].nil? == true #ratings is empty, no more work needs to be done.
      @movies = Movie.all
      session[:ratings]={}
      puts @sortVariable
    
    end
    
    if params[:'ratings'].nil? == false
      @ratings_to_show =params[:'ratings'].keys
      @movies = Movie.where(rating: @ratings_to_show)
      session[:ratings]= Hash[@ratings_to_show.map{|x| [x,1]}]
      session[:sortVar] = @sortVariable
    end
      
    if @sortVariable.nil? == false
      @movies = @movies.order(@sortVariable)
      session[:sortVar] = @sortVariable
      
      
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end