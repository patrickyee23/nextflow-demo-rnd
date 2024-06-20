process simplePrint {
  input:
  val job_index

  output:
  stdout

  """
  echo $job_index
  """
}

workflow {
  jobs = Channel.of(1..100)
  simplePrint(jobs) | view
}
