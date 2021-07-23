class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy]
  LIMIT = 5
  # GET /dogs
  # GET /dogs.json
  def index
    @page_request = params[:page] ? params[:page].to_i : 1
    @offset = @page_request - 1

    @dogs = Dog.offset(@offset * LIMIT).order("name ASC").first(LIMIT)
    @size = Dog.count

    @total_pages = @size / LIMIT

    if @size % LIMIT != 0
      @total_pages += 1
    end

    @pages = Array.new()

    @page_number = 1

    while @page_number <= @total_pages
      if (@page_number != @page_request)
        @pages.push(@page_number)
      end
      @page_number = @page_number + 1
    end

  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)
    if(current_user.id)
      @dog.user = current_user
    end

    respond_to do |format|
      if @dog.save
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if current_user && @dog.user && @dog.user.id == current_user.id && @dog.update(dog_params)

        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    if current_user && @dog.user && @dog.user.id == current_user.id && @dog.destroy
      respond_to do |format|
        format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
      format.html { redirect_to dogs_url, notice: 'Dog was not successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dog_params
      params.require(:dog).permit(:name, :description, :images => [])
    end
end
