#!/bin/bash -l
#SBATCH --job-name=krakenTools
#SBATCH --account=
#SBATCH --output=errout/outputr%j.txt
#SBATCH --error=errout/errors_%j.txt
#SBATCH --partition=small
#SBATCH --time=04:00:00
#SBATCH --ntasks=1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --mem-per-cpu=4000


# load job configuration
cd $SLURM_SUBMIT_DIR
source config_scripts/config.sh

# load environment
source $CONDA/etc/profile.d/conda.sh
conda activate kraken2
KRAKENTOOLS="/scratch/project_2004512/tools/KrakenTools"

# echo for log
echo "job started"; hostname; date

# Get sample ID
export PAIR1=`head -n +${SLURM_ARRAY_TASK_ID} $IN_LIST | tail -n 1`

# create output directories
PAIR2="${PAIR1%%_R1.fq.gz}_R2.fq.gz"
REPORT="${PAIR1%%_R1.fq.gz}_profiles.txt"
OUTPUT="${PAIR1%%_R1.fq.gz}_output.txt"
READS="${PAIR1%%_R1.fq.gz}_taxselection.fa"

python $KRAKENTOOLS/extract_kraken_reads.py -k $OUT_DIR/$OUTPUT -s1 $IN_DIR/$PAIR1 -o $OUT_DIR/$READS -t $TAXID

# echo for log
echo "job done"; date

