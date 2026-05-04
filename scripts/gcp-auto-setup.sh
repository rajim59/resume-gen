#!/bin/bash
# চালানোর অনুমতি দিন: chmod +x scripts/gcp-auto-setup.sh
echo "🔍 Checking if gcloud is installed..."
if ! command -v gcloud &> /dev/null; then
    echo "❌ gcloud SDK not found. Please install from https://cloud.google.com/sdk/docs/install"
    exit 1
fi

echo "🔐 Logging in to GCP (this will open a browser)..."
gcloud auth login
gcloud auth application-default login

echo "🆔 Set your project ID (paste here):"
read PROJECT_ID
gcloud config set project $PROJECT_ID

echo "🔌 Enabling required APIs..."
gcloud services enable firestore.googleapis.com pubsub.googleapis.com cloudfunctions.googleapis.com cloudrun.googleapis.com artifactregistry.googleapis.com

echo "📦 Creating .env file with emulator variables..."
cat > .env <<EOF
FIRESTORE_EMULATOR_HOST=localhost:8081
PUBSUB_EMULATOR_HOST=localhost:8085
GOOGLE_CLOUD_PROJECT=$PROJECT_ID
EOF

echo "✅ GCP is now connected. You can run 'make up' to start local emulators."