.PHONY: sync
sync:
	aws s3 sync data s3://ttam-rnd-scratch-us-west-2/pyee/data/

.PHONY: run
run:
	nextflow run main.nf -resume
