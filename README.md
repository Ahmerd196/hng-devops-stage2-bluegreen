README.md
# HNG DevOps Stage 2 – Blue/Green Deployment

This project uses Docker Compose and Nginx to achieve a zero-downtime Blue/Green deployment. Two identical backend services (`app_blue` and `app_green`) run behind an Nginx reverse proxy that automatically fails over when the active service crashes.

## Setup

1. **Configure environment**: Copy `.env.example` to `.env` and fill in the image names and release IDs:


cp .env.example .env

Edit `.env` and set `BLUE_IMAGE`, `GREEN_IMAGE`, `ACTIVE_POOL` (either `blue` or `green`), and release IDs.

2. **Start services**:  


docker-compose up -d

This will launch:
- Nginx on port 8080
- `app_blue` on port 8081 (container port 80)
- `app_green` on port 8082 (container port 80)

## Usage

- **Check Version**:  
Access the version endpoint through Nginx:


curl -i http://localhost:8080/version

You should see `X-App-Pool: blue` (or `green`) and the `X-Release-Id` header.

- **Switch Active Pool (manual)**:  
To manually switch pools, set `ACTIVE_POOL` to the other pool and regenerate the Nginx config. For example, to switch to green:
```sh
docker compose exec -T nginx sh -lc 'ACTIVE_POOL=green /usr/local/bin/generate-nginx.sh'


Now Nginx will route new traffic to Green (and mark Blue as backup).

Health Check:
Verify the service health:

curl -sf http://localhost:8080/healthz


(Both apps expose a /healthz endpoint.)

Chaos Testing:
Simulate a failure in the Blue app:

curl -X POST http://localhost:8081/chaos/start


This causes app_blue to return 500 errors. Then, requests to Nginx should continue to succeed via the Green app:

curl -i http://localhost:8080/version


Check that X-App-Pool: green appears in the response headers and no 500 errors occur.

Restore After Chaos:
Stop the chaos on Blue to bring it back:

curl -X POST http://localhost:8081/chaos/stop


Stop services:

docker-compose down