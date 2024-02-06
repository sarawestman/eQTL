#!/bin/bash
#SBATCH -A XXXXXXX
#SBATCH --job-name=myarrayjob
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --array=1-40
#SBATCH -t 01:00:00
#SBATCH --mail-user=YYYYYYYY
#SBATCH --mail-type=FAIL

# Specify the path to the config file
config=/proj/XXXXXX/chemotypes/data/Array4eQTL.tsv

# Extract the gene name for the current $SLURM_ARRAY_TASK_ID
gene=$(awk -F"\t" -v BatchNr=${1} -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '($3==ArrayTaskID) && ($2==BatchNr) {print $1}' $config)

# Print to a file a message that includes the current $SLURM_ARRAY_TASK_ID, the gene name
echo "Batch ${1} and array task ${SLURM_ARRAY_TASK_ID}. Gene name: ${gene}" >> /proj/XXXXXX/chemotypes/scripts/output_array5.txt

module load R_packages/4.1.1

Rscript /proj/XXXXXX/chemotypes/scripts/runFastJT.R ${gene}
