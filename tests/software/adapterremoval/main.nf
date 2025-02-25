#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { ADAPTERREMOVAL } from '../../../software/adapterremoval/main.nf' addParams( options: [:] )

workflow test_adapterremoval_single_end {
    
    def input = []
    input = [ [ id:'test', single_end:true, collapse:false ], // meta map
              file("${launchDir}/tests/data/genomics/sarscov2/fastq/test_1.fastq.gz", checkIfExists: true) ]

    ADAPTERREMOVAL ( input )
}

workflow test_adapterremoval_paired_end {
    
    def input = []
    input = [ [ id:'test', single_end:false, collapse:false ], // meta map
              [ file("${launchDir}/tests/data/genomics/sarscov2/fastq/test_1.fastq.gz", checkIfExists: true),
                file("${launchDir}/tests/data/genomics/sarscov2/fastq/test_2.fastq.gz", checkIfExists: true) ]]

    ADAPTERREMOVAL ( input )
}

workflow test_adapterremoval_paired_end_collapse {
    
    def input = []
    input = [ [ id:'test', single_end:false, collapse:true ], // meta map
              [ file("${launchDir}/tests/data/genomics/sarscov2/fastq/test_1.fastq.gz", checkIfExists: true),
                file("${launchDir}/tests/data/genomics/sarscov2/fastq/test_2.fastq.gz", checkIfExists: true) ]]

    ADAPTERREMOVAL ( input )
}

