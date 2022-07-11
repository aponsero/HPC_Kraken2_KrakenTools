#!/bin/bash -l
#SBATCH --job-name=krake
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

# echo for log
echo "job started"; hostname; date

# Get sample ID
export PAIR1=`head -n +${SLURM_ARRAY_TASK_ID} $IN_LIST | tail -n 1`

# create output directories
PAIR2="${PAIR1%%_R1.fq.gz}_R2.fq.gz"
REPORT="${PAIR1%%_R1.fq.gz}_profiles.txt"
OUTPUT="${PAIR1%%_R1.fq.gz}_output.txt"

#kraken2 --paired --db $DBNAME --output $OUT_DIR/$OUTPUT --report $OUT_DIR/$SAMPLE $IN_DIR/$PAIR1 $IN_DIR/$PAIR2

kraken2 --db $DBNAME --report $OUT_DIR/$REPORT --output $OUT_DIR/$OUTPUT $IN_DIR/$PAIR1

# echo for log
echo "job done"; date

