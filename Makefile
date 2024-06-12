ACCOUNT_ID=$(shell aws sts get-caller-identity --query Account --output text)
AWS_DEFAULT_REGION?=us-west-2
IMAGE_NAME?=pyee/nextflow-demo-rnd
IMAGE_TAG?=1.0
ECR_HOST=$(ACCOUNT_ID).dkr.ecr.$(AWS_DEFAULT_REGION).amazonaws.com
IMAGE_NAME_TAG=$(IMAGE_NAME):$(IMAGE_TAG)
FULL_IMAGE_NAME_TAG=$(ECR_HOST)/$(IMAGE_NAME):$(IMAGE_TAG)
PROXY_CFG:=NO_PROXY=*s3*
S3_ROOT:=s3://ttam-rnd-metaflow-us-west-2/30-day-expire/pyee


# Note: all the following need RND credentials
.PHONY: sync
sync:
	aws s3 sync data $(S3_ROOT)/data/

# Note: run in Jupyter instance
.PHONY: run
run:
	$(PROXY_CFG) nextflow run main.nf -resume -bucket-dir $(S3_ROOT)/workdir/

# NOTE: don't run the following on Apple Silicon machine
.PHONY: build-image
build-image:
	docker build -t $(IMAGE_NAME_TAG) .

.PHONY: push-image
push-image: build-image
	docker tag $(IMAGE_NAME_TAG) $(FULL_IMAGE_NAME_TAG)
	aws ecr create-repository --repository-name $(IMAGE_NAME) --region $(AWS_DEFAULT_REGION) || true
	aws ecr get-login-password --region $(AWS_DEFAULT_REGION) | docker login --username AWS --password-stdin $(ECR_HOST)
	docker push $(FULL_IMAGE_NAME_TAG)
