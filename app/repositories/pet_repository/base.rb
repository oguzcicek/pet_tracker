module PetRepository
  class Base
    def create_or_update_pet(_data)
      raise NotImplementedError
    end

    def fetch_pets_outside_zone
      raise NotImplementedError
    end

    def grouped_pets_outside_zone
      raise NotImplementedError
    end

    def all_pets
      raise NotImplementedError
    end

    def delete_pet(_id)
      raise NotImplementedError
    end
  end
end
