require "rails_helper"

RSpec.describe Pet, type: :model do
  it "is valid with a Dog, small tracker, and an owner_id" do
    pet = Pet.new(pet_type: "Dog", tracker_type: "small", owner_id: 1)
    expect(pet).to be_valid
  end

  it "is invalid without a pet_type" do
    pet = Pet.new(tracker_type: "small", owner_id: 1)
    expect(pet).not_to be_valid
  end

  it "is invalid if tracker_type is not in dog's list" do
    pet = Pet.new(pet_type: "Dog", tracker_type: "giant", owner_id: 1)
    expect(pet).not_to be_valid
  end

  it "has lost_tracker default false if cat" do
    cat = Pet.create(pet_type: "Cat", tracker_type: "small", owner_id: 999)
    expect(cat.lost_tracker).to eq(false)
  end
end
