require "rails_helper"

RSpec.describe PetRepository::ActiveRecord do
  let(:repo) { described_class.new }

  describe "#create_or_update_pet" do
    it "creates a new Pet record in the database" do
      pet = repo.create_or_update_pet(pet_type: "Dog", tracker_type: "small", owner_id: 10)
      expect(pet).to be_a(::Pet)
      expect(pet.id).not_to be_nil
      expect(pet.tracker_type).to eq("small")
    end
  end

  describe "#fetch_pets_outside_zone" do
    it "returns pets that are outside zone" do
      repo.create_or_update_pet(pet_type: "Dog", tracker_type: "medium", owner_id: 11, in_zone: false)
      outside = repo.fetch_pets_outside_zone
      expect(outside.count).to eq(1)
      expect(outside.first.owner_id).to eq(11)
    end
  end

  describe "#grouped_pets_outside_zone" do
    it "groups pets by pet_type and tracker_type" do
      repo.create_or_update_pet(pet_type: "Cat", tracker_type: "small", owner_id: 12, in_zone: false)
      groups = repo.grouped_pets_outside_zone
      expect(groups["Cat"]["small"]).to eq(1)
    end
  end

  describe "#delete_pet" do
    it "deletes a pet by ID" do
      pet = repo.create_or_update_pet(pet_type: "Cat", tracker_type: "big", owner_id: 13)
      repo.delete_pet(pet.id)
      expect(::Pet.find_by(id: pet.id)).to be_nil
    end
  end
end
