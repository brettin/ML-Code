#!/bin/bash
#BSUB -W 8:00
#BSUB -nnodes 674
#BSUB -P med110
#BSUB -J CANCERInfer.ENA
#BSUB -alloc_flags NVME
#BSUB -N hsyoo@anl.gov

model_dir="/gpfs/alpine/med110/proj-shared/hsyoo/CANCER/ML-models"

unset OMP_NUM_THREADS

module load ibm-wml-ce
export PATH="/gpfs/alpine/med110/proj-shared/hsyoo/CANCER/ML-training-inferencing/inferencing:$PATH"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# --nnodes has to equal the number of times jsrun is called.

for i in $(seq 0 6 4039) ; do
  jsrun -n 6 -a 1 -c 7 -g 1 reg_go_infer_dg.sh $i ENA/ENA.input $model_dir > ENA.input."$i".log 2>&1 &
  sleep 2
done
