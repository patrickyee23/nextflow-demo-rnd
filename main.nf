s3_root = "s3://ttam-rnd-scratch-us-west-2/pyee/data"

process printSummary {
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
