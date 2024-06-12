s3_root = "s3://ttam-rnd-metaflow-us-west-2/30-day-expire/pyee/data"

process printSummary {
   executor = "awsbatch"
   queue = "metaflow-job-queue"
   // in this demo, this is built and pushed using Makefile; ideally, we'll setup CI/CD to build the image
   container = "593846400773.dkr.ecr.us-west-2.amazonaws.com/pyee/nextflow-demo-rnd:1.0"
   cpus 1
   memory "0.5 GB"

   publishDir "$s3_root", mode: "copy" , overwrite: true

   input:
   path data

   output:
   path "summary.txt"

   """
   Rscript -e "print(summary(read.csv('$data')))" > summary.txt
   """
}

workflow {
   printSummary("$s3_root/railway.csv") | view
}
