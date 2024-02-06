#!/bin/bash -l

set -euo pipefail

# Usage: bash loopArray.sh

start=701 # you can have 7000 jobs at once - i.e. 175 batches
end=846
batchVal=$(seq $start $end)

for val in $batchVal; do
  sbatch /proj/XXXXXX/chemotypes/scripts/arrayFastJT.sh ${val} 
done
