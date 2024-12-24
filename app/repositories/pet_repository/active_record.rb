module PetRepository
  class ActiveRecord < Base
    def create_or_update_pet(data)
      ::Pet.create!(data)
    end

    def fetch_pets_outside_zone
      ::Pet.where(in_zone: false)
    end

    def grouped_pets_outside_zone
      pets = fetch_pets_outside_zone
      result = {}
      pets.group_by(&:pet_type).each do |pet_type, group|
        result[pet_type] = group.group_by(&:tracker_type).transform_values(&:count)
      end
      result
    end

    def all_pets
      ::Pet.all
    end

    def delete_pet(id)
      pet = ::Pet.find_by(id: id)
      pet&.destroy
    end
  end
end
