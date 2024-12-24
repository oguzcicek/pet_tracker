require 'rails_helper'

RSpec.describe "Pets API", type: :request do
  describe "GET /api/v1/pets" do
    it "returns all pets" do
      Pet.create!(pet_type: "Cat", tracker_type: "small", owner_id: 10)
      get "/api/v1/pets"
      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)
      expect(data).to be_an(Array)
      expect(data.size).to eq(1)
    end
  end

  describe "POST /api/v1/pets" do
    it "creates a new pet" do
      post "/api/v1/pets", params: { pet: { pet_type: "Dog", tracker_type: "small", owner_id: 20 } }
      expect(response).to have_http_status(:created)
      data = JSON.parse(response.body)
      expect(data["pet_type"]).to eq("Dog")
    end
  end

  describe "GET /api/v1/pets/outside_count" do
    it "returns grouped data for pets outside zone" do
      Pet.create!(pet_type: "Dog", tracker_type: "small", owner_id: 30, in_zone: false)
      get "/api/v1/pets/outside_count"
      expect(response).to have_http_status(:ok)
      result = JSON.parse(response.body)
      expect(result).to be_a(Hash)
      expect(result["Dog"]["small"]).to eq(1)
    end
  end

  describe "DELETE /api/v1/pets/:id" do
    it "deletes a pet" do
      pet = Pet.create!(pet_type: "Dog", tracker_type: "medium", owner_id: 40)
      delete "/api/v1/pets/#{pet.id}"
      expect(response).to have_http_status(:no_content)
      expect(Pet.find_by(id: pet.id)).to be_nil
    end
  end
end
