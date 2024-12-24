require "redis"

module PetRepository
  class Redis < Base
    def initialize
      @redis = ::Redis.new(host: "127.0.0.1", port: 6379)
    end

    def create_or_update_pet(data)
      id = generate_id
      key = "pets:#{id}"

      in_zone_str = data[:in_zone].nil? ? "true" : data[:in_zone].to_s
      lost_tracker_str = data[:lost_tracker].nil? ? "false" : data[:lost_tracker].to_s

      @redis.hset(key, "id", id)
      @redis.hset(key, "pet_type", data[:pet_type])
      @redis.hset(key, "tracker_type", data[:tracker_type])
      @redis.hset(key, "owner_id", data[:owner_id])
      @redis.hset(key, "in_zone", in_zone_str)
      @redis.hset(key, "lost_tracker", lost_tracker_str)

      fetch_pet_hash(key)
    end

    def fetch_pets_outside_zone
      pet_keys.map { |key| fetch_pet_hash(key) }
              .compact
              .select { |pet| pet["in_zone"] == "false" }
    end

    def grouped_pets_outside_zone
      grouped = {}
      fetch_pets_outside_zone.each do |pet|
        pt = pet["pet_type"]
        tt = pet["tracker_type"]
        grouped[pt] ||= {}
        grouped[pt][tt] ||= 0
        grouped[pt][tt] += 1
      end
      grouped
    end

    def all_pets
      pet_keys.map { |key| fetch_pet_hash(key) }.compact
    end

    def delete_pet(id)
      key = "pets:#{id}"
      @redis.del(key) > 0
    end

    private

    def pet_keys
      @redis.keys("pets:*")
    end

    def fetch_pet_hash(key)
      data = @redis.hgetall(key)
      data.empty? ? nil : data
    end

    def generate_id
      @redis.incr("pets_sequence")
    end
  end
end
