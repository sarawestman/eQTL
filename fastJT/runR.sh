#!/bin/bash
#SBATCH -A naiss2023-5-323
#SBATCH -p core
#SBATCH -n 10
#SBATCH -t 3-00:00:00
#SBATCH --mail-user=sara.westman@umu.se
#SBATCH --mail-type=FAIL

module load R_packages/4.1.1

Rscript $@
