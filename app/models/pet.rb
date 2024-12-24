class Pet < ApplicationRecord
    # Constants
    CAT_TRACKERS = %w[small big].freeze
    DOG_TRACKERS = %w[small medium big].freeze
  
    # Validations
    validates :pet_type, presence: true, inclusion: { in: %w[Cat Dog] }
    validates :tracker_type, presence: true
    validates :owner_id, presence: true
  
    validate :validate_tracker_type
  
    private
  
    def validate_tracker_type
      if pet_type == "Cat" && !CAT_TRACKERS.include?(tracker_type)
        errors.add(:tracker_type, "invalid for Cat (must be 'small' or 'big')")
      elsif pet_type == "Dog" && !DOG_TRACKERS.include?(tracker_type)
        errors.add(:tracker_type, "invalid for Dog (must be 'small', 'medium', or 'big')")
      end
    end
end
