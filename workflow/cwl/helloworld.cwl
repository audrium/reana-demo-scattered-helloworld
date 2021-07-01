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

requirements:
  ScatterFeatureRequirement: {}
  SubworkflowFeatureRequirement: {}

inputs:
  helloworld: File
  inputfile: File
  sleeptime: int
  scatterarray: string[]

outputs:
  result:
    type: File
    outputSource: first/result

steps:
  first:
    run: helloworld.tool
    in:
      helloworld: helloworld
      inputfile: inputfile
      sleeptime: sleeptime
      stepname:
        default: "first"
      outputfile:
        default: results/first.txt
    out: [result]

  second:
    run: helloworld.tool
    in:
      helloworld: helloworld
      inputfile: inputfile
      sleeptime: sleeptime
      stepname:
        default: "second"
      outputfile:
        default: results/second.txt
    out: [result]

  scattered:
    run: helloworld.tool
    scatter: message
    in:
      helloworld: helloworld
      stepname:
        default: "scattered"
      message: scatterarray
      inputfile: inputfile
      sleeptime: sleeptime
      outputfile:
        default: results/scattered.txt
    out: [result]

  nested:
    run:
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
    in:
      helloworld: helloworld
      inputfile: inputfile
      sleeptime: sleeptime
    out: [result]
