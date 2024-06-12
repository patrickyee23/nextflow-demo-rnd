
process printSummary {
   input:
   path data

   output:
   path summary.txt

   """
   Rscript -e "print(summary(read.csv('$x')))" > summary.txt
   """
}

workflow {
   printSummary("s3://ttam-rnd-scratch-us-west-2/pyee/data/rail.csv") | view
}
