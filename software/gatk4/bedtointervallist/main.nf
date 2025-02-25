// Import generic module functions
include { initOptions; saveFiles; getSoftwareName } from './functions'

params.options = [:]
options        = initOptions(params.options)

process GATK4_BEDTOINTERVALLIST {
    tag "$meta.id"
    label 'process_medium'
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), publish_id:meta.id) }

    conda (params.enable_conda ? 'bioconda::gatk4=4.1.9.0' : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container 'https://depot.galaxyproject.org/singularity/gatk4:4.1.9.0--py39_0'
    } else {
        container 'quay.io/biocontainers/gatk4:4.1.9.0--py39_0'
    }

    input:
    tuple val(meta), path(bed)
    path sequence_dict

    output:
    tuple val(meta), path('*.interval_list'), emit: interval_list
    path  '*.version.txt'                   , emit: version

    script:
    def software = getSoftwareName(task.process)
    def prefix   = options.suffix ? "${meta.id}.${options.suffix}" : "${meta.id}"
    """
    gatk BedToIntervalList \\
        -I $bed \\
        -SD $sequence_dict \\
        -O ${prefix}.interval_list \\
        $options.args

    gatk --version | grep Picard | sed "s/Picard Version: //g" > ${software}.version.txt
    """
}
