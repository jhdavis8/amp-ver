#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --mem=1006G
#SBATCH --job-name="ampver"
#SBATCH --partition=_workgroup_
# SBATCH --partition=standard                                                                                 
#SBATCH --time=0-12:00:00
#SBATCH --exclusive
# SBATCH --output=%x-%j.out
# SBATCH --error=%x-%j.out
# SBATCH --export=NONE
vpkg_require jdk/17 gcc/8.1.0
srun make out/CoarseHashSet_1.out
