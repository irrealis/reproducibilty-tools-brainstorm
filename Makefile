
IMAGE_USER := irrealis
IMAGE_REPO := example-analysis
IMAGE_SOURCE := ${IMAGE_USER}/${IMAGE_REPO}
IMAGE_VERSION := $$(git describe --first-parent)
IMAGE_TAG := ${IMAGE_SOURCE}:${IMAGE_VERSION}
IMAGE_TAG_LATEST := ${IMAGE_SOURCE}:latest

example-docker-image:
	@docker build -t ${IMAGE_TAG} -t ${IMAGE_TAG_LATEST} -f example-analysis/containers/Dockerfile.nixos example-analysis

${IMAGE_REPO}.simg:
	@singularity build ${IMAGE_REPO}.simg example-analysis/containers/Singularity

testing:
	@echo IMAGE_TAG: ${IMAGE_TAG}
