require "rails_helper"

RSpec.describe PetRepository::Redis do
  let(:repo) { described_class.new }
  let(:redis_client) { ::Redis.new(host: "127.0.0.1", port: 6379) }

  before do
    redis_client.flushdb
  end

  describe "#create_or_update_pet" do
    it "stores a pet record in Redis" do
      pet_hash = repo.create_or_update_pet(pet_type: "Dog", tracker_type: "small", owner_id: 20)
      expect(pet_hash).to be_a(Hash)
      expect(pet_hash["pet_type"]).to eq("Dog")
      expect(pet_hash["tracker_type"]).to eq("small")
      expect(pet_hash["in_zone"]).to eq("true") # default
    end

    it "sets in_zone to false string if data says so" do
      pet_hash = repo.create_or_update_pet(pet_type: "Cat", tracker_type: "big", owner_id: 21, in_zone: false)
      expect(pet_hash["in_zone"]).to eq("false")
    end
  end

  describe "#fetch_pets_outside_zone" do
    it "returns pets that have in_zone = 'false'" do
      repo.create_or_update_pet(pet_type: "Cat", tracker_type: "small", owner_id: 22, in_zone: false)
      result = repo.fetch_pets_outside_zone
      expect(result.size).to eq(1)
      expect(result.first["owner_id"]).to eq("22")
      expect(result.first["in_zone"]).to eq("false")
    end
  end

  describe "#grouped_pets_outside_zone" do
    it "groups outside pets by type and tracker" do
      repo.create_or_update_pet(pet_type: "Dog", tracker_type: "medium", owner_id: 23, in_zone: false)
      groups = repo.grouped_pets_outside_zone
      expect(groups["Dog"]["medium"]).to eq(1)
    end
  end

  describe "#delete_pet" do
    it "deletes a redis pet key" do
      pet_hash = repo.create_or_update_pet(pet_type: "Dog", tracker_type: "medium", owner_id: 24)
      id = pet_hash["id"]
      result = repo.delete_pet(id)
      expect(result).to be_truthy
      all_keys = redis_client.keys("pets:*")
      expect(all_keys).to be_empty
    end
  end
end
