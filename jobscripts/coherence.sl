#!/bin/bash
#SBATCH --job-name=coherence
#SBATCH --account=def-wjmarsha
#SBATCH --time=0-30:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --bc11xx@brocku.ca
#SBATCH --mail-type=ALL
#SBATCH --output=no_voc_task_301-%j.out

# Load MATLAB module
module load matlab/2019a
# Try running matlab script to compute no voc task 301
srun matlab -nodisplay -singleCompThread -r "no_voc_task_301_coherence.m"
