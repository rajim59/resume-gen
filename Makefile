.PHONY: help install setup-env up down logs clean gcp-connect

help:
	@echo "📌 Available commands:"
	@echo "  make setup-env   - Create .env from example"
	@echo "  make up          - Start all services (Docker Compose)"
	@echo "  make down        - Stop all services"
	@echo "  make logs        - Show logs"
	@echo "  make clean       - Remove containers, volumes, cache"
	@echo "  make gcp-connect - Authenticate GCP & set project"

setup-env:
	cp .env.example .env || touch .env

up:
	docker-compose up --build

down:
	docker-compose down

logs:
	docker-compose logs -f

clean:
	docker-compose down -v
	docker system prune -f
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true

gcp-connect:
	@echo "🔐 Logging into Google Cloud..."
	gcloud auth login
	gcloud config set project YOUR_GCP_PROJECT_ID
	gcloud auth application-default login
	@echo "✅ GCP credentials saved. Firestore/PubSub emulators will auto-detect."