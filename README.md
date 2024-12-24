# Pet Tracking Application

This application manages **Dogs** and **Cats** with different tracker types, allowing you to:
1. Create new pet records  
2. Query all pets  
3. Query the pets that are **outside** the power saving zone, grouped by pet type and tracker type  
4. Delete pet records  

It uses:
- **Rails** (API-only configuration).
- **Service–Repository pattern** for flexible storage (supports both ActiveRecord and Redis).
- **RSpec** for testing (models, requests, repositories).
- **MockRedis** or real Redis for in-memory usage, and SQLite (by default) for ActiveRecord.

---

## Table of Contents

1. [Architecture Overview](#architecture-overview)  
2. [How to Run](#how-to-run)  
3. [How to Test](#how-to-test)  
4. [REST API Endpoints](#rest-api-endpoints)  

---

## Architecture Overview

- **Models** (e.g., `Pet`) define validations and basic data structure.  
- **Repositories** (e.g., `PetRepository::ActiveRecord`, `PetRepository::Redis`) abstract the data access layer so we can switch between an in-memory or a persistent database without changing other code.  
- **Services** (e.g., `PetDataService`) hold the core business logic and orchestrate between controllers and repositories.  
- **Controllers** (e.g., `Api::V1::PetsController`) provide RESTful endpoints, delegating database calls to the **service layer**.  

This architecture makes it easy to replace the storage layer if you want to switch from Redis to ActiveRecord or vice versa.

---

## How to Run

1. **Install dependencies**  
   ```bash
   bundle install
2. **Migrate the database**  
    ```bash
    rails db:migrate
3. **Start the server**
    ```bash
    rails server
The application will be running at http://localhost:3000.

By default, it uses ActiveRecord with SQLite. If you want to use Redis as a data store, make sure Redis is running (redis-server), and set an environment variable like USE_REDIS=1 before starting the server:

    USE_REDIS=1 rails server
    
---

## How to Test

Run all RSpec tests (models, repositories, requests, etc.):

    bundle exec rspec

MockRedis is used in the tests to avoid requiring a live Redis server (unless you choose to test with USE_REDIS=1).

---

## REST API Endpoints

All endpoints return JSON. The base URL is typically `http://localhost:3000`.

### 1. List All Pets  
 
GET /api/v1/pets
  
    curl -X GET http://localhost:3000/api/v1/pets

#### Response Example:

    [
        {
            "id": 1,
            "pet_type": "Cat",
            "tracker_type": "small",
            "owner_id": 10,
            "in_zone": true,
            "lost_tracker": false
        }
    ]

### 2. Create a New Pet

POST /api/v1/pets
  
    curl -X POST http://localhost:3000/api/v1/pets \
     -H 'Content-Type: application/json' \
     -d '{
           "pet": {
             "pet_type": "Dog",
             "tracker_type": "small",
             "owner_id": 123,
             "in_zone": false,
             "lost_tracker": false
           }
         }'

#### Response Example:

    {
        "id": 42,
        "pet_type": "Dog",
        "tracker_type": "small",
        "owner_id": 123,
        "in_zone": false,
        "lost_tracker": false
    }

### 3. Get Outside Pets Count

GET /api/v1/pets/outside_count

    curl -X GET http://localhost:3000/api/v1/pets/outside_count

#### Response Example:

    {
        "Dog": {
            "small": 1,
            "medium": 2
        },
        "Cat": {
            "big": 1
        }
    }

### 4. Delete a Pet

DELETE /api/v1/pets/:id

    curl -X DELETE http://localhost:3000/api/v1/pets/1

Response: Returns a 204 No Content status on success.

