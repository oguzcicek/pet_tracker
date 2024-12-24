Rails.application.config.to_prepare do
  if ENV["USE_REDIS"] == "1"
    Rails.logger.info "Using Redis-based PetRepository"
    $pet_repository = PetRepository::Redis.new
  else
    Rails.logger.info "Using ActiveRecord-based PetRepository"
    $pet_repository = PetRepository::ActiveRecord.new
  end
end
