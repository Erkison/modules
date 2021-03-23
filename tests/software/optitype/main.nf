#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { OPTITYPE } from '../../../software/optitype/main.nf' addParams( options: ['args':'-e 1 -b 0.009', 'args2':'--solver "glpk"'] )

workflow test_optitype {

    def input = []
    input = [ [ id:'test', seq_type:'DNA' ], // meta map
              file("${launchDir}/tests/data/genomics/sarscov2/bam/test_single_end.sorted.bam", checkIfExists: true) ]

    OPTITYPE ( input )
}
