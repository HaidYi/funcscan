process RENAME_INPUTS {
    tag "$meta.sample"
    label 'process_low'

    conda "conda-forge::pigz=2.8"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/pigz:2.8' :
        'biocontainers/pigz:2.8' }"

    input:
    tuple val(meta), path(fasta), path(faa), path(gbk)

    output:
    tuple val(meta), path("${meta.sample}.fasta"), emit: fasta_renamed
    tuple val(meta), path("${meta.sample}.faa"), emit: faa_renamed, optional: true
    tuple val(meta), path("${meta.sample}.gbk"), emit: gbk_renamed, optional: true

    script:
    def fastaName = fasta.getName()
    def fastaCmd = fastaName == "${meta.sample}.fasta" ? "ln -s ${fasta} ${meta.sample}.fasta" : "cp ${fasta} ${meta.sample}.fasta"

    def faaCmd = faa ? (
        faa.getName() == "${meta.sample}.faa" ? "ln -s ${faa} ${meta.sample}.faa" : "cp ${faa} ${meta.sample}.faa"
    ) : ""

    def gbkCmd = gbk ? (
        gbk.getName() == "${meta.sample}.gbk" ? "ln -s ${gbk} ${meta.sample}.gbk" : "cp ${gbk} ${meta.sample}.gbk"
    ) : ""

    """
    ${fastaCmd}
    ${faaCmd}
    ${gbkCmd}
    """
}
