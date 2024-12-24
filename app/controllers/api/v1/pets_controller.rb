module Api
  module V1
    class PetsController < ApplicationController
      # GET /api/v1/pets
      def index
        pets = PetDataService.all_pets
        render json: pets, status: :ok
      end

      # POST /api/v1/pets
      def create
        pet = PetDataService.create_or_update_pet(pet_params)
        render json: pet, status: :created
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      # GET /api/v1/pets/outside_count
      def outside_count
        data = PetDataService.grouped_pets_outside_zone
        render json: data, status: :ok
      end

      # DELETE /api/v1/pets/:id
      def destroy
        if PetDataService.delete_pet(params[:id])
          head :no_content
        else
          render json: { error: "Pet not found" }, status: :not_found
        end
      end

      private

      def pet_params
        params.require(:pet).permit(:pet_type, :tracker_type, :owner_id, :in_zone, :lost_tracker)
      end
    end
  end
end
