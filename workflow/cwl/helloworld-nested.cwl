#!/usr/bin/env cwl-runner

# Note that if you are working on the analysis development locally, i.e. outside
# of the REANA platform, you can proceed as follows:
#   $ mkdir cwl-local-run
#   $ cd cwl-local-run
#   $ cp ../code/* ../data/* ../workflow/cwl/helloworld-job.yml .
#   $ cwltool --quiet --outdir="../outputs"
#           ../workflow/cwl/helloworld.cwl helloworld-job.yml
#   $ cat results/greetings.txt
#   Hello Jane Doe!
#   Hello Joe Bloggs!


cwlVersion: v1.0
class: Workflow

inputs:
  helloworld: File
  inputfile: File
  sleeptime: int

outputs:
  result:
    type: File
    outputSource: nested_first/result

steps:
  nested_first:
    run: helloworld.tool
    in:
      helloworld: helloworld
      stepname:
        default: "nested_first"
      inputfile: inputfile
      sleeptime: sleeptime
      outputfile:
        default: results/nested.txt
    out: [result]
  nested_second:
    run: helloworld.tool
    in:
      helloworld: helloworld
      stepname:
        default: "nested_second"
      inputfile: inputfile
      sleeptime: sleeptime
      outputfile:
        default: results/nested.txt
    out: [result]
