
IMAGE_USER := irrealis
IMAGE_REPO := example-analysis
IMAGE_SOURCE := ${IMAGE_USER}/${IMAGE_REPO}
IMAGE_VERSION := $$(git describe --first-parent --dirty)
IMAGE_TAG := ${IMAGE_SOURCE}:${IMAGE_VERSION}
IMAGE_TAG_LATEST := ${IMAGE_SOURCE}:latest

example-docker-image:
	@docker build -t ${IMAGE_TAG} -t ${IMAGE_TAG_LATEST} -f example-analysis/containers/Dockerfile.nixos example-analysis


#example-analysis/${IMAGE_REPO}.img:
example-singularity-image:
	#@singularity build ${IMAGE_REPO}.simg example-analysis/containers/Singularity.nixos
	@cd example-analysis && rm -f ${IMAGE_REPO} ; singularity build ${IMAGE_REPO} containers/Singularity.nixos

#example-singularity-image: example-analysis/${IMAGE_REPO}.img

testing:
	@echo IMAGE_TAG: ${IMAGE_TAG}
