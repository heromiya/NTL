#!/bin/bash

LOG=qsub_exec.log
#$ -cwd
#$ -o qsub_exec.log
#$ -l q_core=1
#$ -l h_rt=01:00:00
#$ -N NTL
#$ -j y
#$ -m abe
#$ -M heromiya@hotmail.com

#mkdir -p qsub.log.d
#rm -f qsub.log.d/qsub_exec.sh.log
#rm -f $LOG

echo "### $(date +'%F_%T')" >> $LOG
. /etc/profile.d/modules.sh
#module load intel cuda/9.0.176 nccl/2.4.2 cudnn/7.4 tensorflow/1.12.0
. /home/7/17IA0902/anaconda3/etc/profile.d/conda.sh
#/home/7/17IA0902/anaconda3/bin/python train.py

export PATH=/home/7/17IA0902/anaconda3/bin/:$PATH
export PROJ_LIB=/gs/hs0/tgh-20IAV/miyazaki/proj
bash -x getNTL.sh
bash -x cal_median.sh
bash -x buildTimeSeries.sh
