#!/usr/bin/env nextflow
nextflow.enable.dsl = 2

// Define the workflow
workflow {
    // Create a channel emitting a tuple of the paired-end FASTQ files
    reads_ch = Channel.of(params.reads)

    // Run the fastp process to trim reads
    trimmed_ch = fastp(reads_ch)

    // Assemble the trimmed reads using SKESA
    assembled_ch = skesa(trimmed_ch)

    // Generate statistics using seqkit
    stats_ch = seqkit(trimmed_ch)
}

// Process: fastp
process fastp {
    publishDir 'results/fastp', mode: 'copy'

    input:
    tuple path(read1), path(read2)

    output:
    tuple path('trimmed_1.fastq.gz'), path('trimmed_2.fastq.gz')

    script:
    """
    fastp -i $read1 -I $read2 -o trimmed_1.fastq.gz -O trimmed_2.fastq.gz
    """
}

// Process: skesa
process skesa {
    publishDir 'results/skesa', mode: 'copy'

    input:
    tuple path(read1), path(read2)

    output:
    path 'contigs.fasta'

    script:
    """
    skesa --fastq $read1,$read2 --contigs_out contigs.fasta
    """
}

// Process: seqkit
process seqkit {
    publishDir 'results/seqkit', mode: 'copy'

    input:
    tuple path(read1), path(read2)

    output:
    path 'stats.txt'

    script:
    """
    seqkit stats $read1 $read2 > stats.txt
    """
}
