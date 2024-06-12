PROXY_CFG:=NO_PROXY=*s3*

.PHONY: sync
sync:
	aws s3 sync data s3://ttam-rnd-scratch-us-west-2/pyee/data/

.PHONY: run
run:
	$(PROXY_CFG) nextflow run main.nf -resume
