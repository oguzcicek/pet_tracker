class PetDataService
  def self.create_or_update_pet(data)
    $pet_repository.create_or_update_pet(data)
  end

  def self.fetch_pets_outside_zone
    $pet_repository.fetch_pets_outside_zone
  end

  def self.grouped_pets_outside_zone
    $pet_repository.grouped_pets_outside_zone
  end

  def self.all_pets
    $pet_repository.all_pets
  end

  def self.delete_pet(id)
    $pet_repository.delete_pet(id)
  end
end
