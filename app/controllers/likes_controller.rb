class LikesController < ApplicationController
  before_action :set_dog, only: [:show, :update]

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    
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
