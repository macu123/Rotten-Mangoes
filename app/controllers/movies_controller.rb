class MoviesController < ApplicationController
  def index
    @movies = Movie.all
    @movies = @movies.with_title_or_director(params[:title_or_director]) if params[:title_or_director].present?

    return if params[:duration].blank?

    string_array = params[:duration].split(",")
    if string_array.length == 1
      @movies = @movies.duration_longer_than(string_array[0])
    else
      @movies = @movies.duration_within_range(string_array[0], string_array[1])
    end
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to movies_path, notice: "#{@movie.title} was submitted successfully!"
    else
      render :new
    end
  end

  def update
    @movie = Movie.find(params[:id])

    if @movie.update_attributes(movie_params)
      redirect_to movie_path(@movie), notice: "#{@movie.title} was updated successfully!"
    else
      render :edit
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path, notice: "#{@movie.title} was deleted successfully!"
  end

  protected

  def movie_params
    params.require(:movie).permit(:title, :release_date, :director, :runtime_in_minutes, :poster_image_url, :image, :description)
  end
end