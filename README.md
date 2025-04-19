# my-wf-repo
# BIOL7210 Workflow Assignment

## Nextflow version
v24.10.5

## OS
macOS / Linux / WSL2

This is a reproducible Nextflow workflow for paired-end read trimming, assembly, and QC.

## Test Data
Test FASTQ files used:
- `data/SRR15242907_1.fastq.gz`
- `data/SRR15242907_2.fastq.gz`
(Paired-end Illumina reads, public SRA: SRR15242907)

## How to Run

```bash
conda create -n nf -c bioconda nextflow -y
conda activate nf
nextflow run main.nf -profile test,conda
nextflow run main.nf -profile test,conda -with-timeline timeline.html -resume
# Install graphviz
nextflow run main.nf -profile test,conda -with-dag workflow.dot -resume
dot -Tpng workflow.dot -o workflow.png
