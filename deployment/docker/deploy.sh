#!/bin/bash
# Docker deployment script for Agent Factory

set -e

IMAGE_NAME=${IMAGE_NAME:-"agent-factory"}
IMAGE_TAG=${IMAGE_TAG:-"latest"}
DOCKERFILE=${DOCKERFILE:-"docker/Dockerfile"}

echo "🐳 Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"

# Build the image
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} -f ${DOCKERFILE} .

echo "✅ Image built successfully"

# Optionally push to registry
if [ -n "$DOCKER_REGISTRY" ]; then
    echo "📤 Pushing to registry: ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
    docker push ${DOCKER_REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
    echo "✅ Image pushed successfully"
fi

echo "🚀 Deployment complete!"
echo ""
echo "To run the container:"
echo "  docker run -p 8000:8000 -e OPENAI_API_KEY=your_key ${IMAGE_NAME}:${IMAGE_TAG}"
