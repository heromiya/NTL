#!/bin/bash

#mkdir -p qsub.log.d
#LOG=qsub.log.d/qsub_exec.`date +%s`.log
#qsub -g tgh-20IAV qsub_exec.sh
#$ -cwd
#$ -o qsub_exec.log
#$ -l q_core=1
#$ -l h_rt=02:00:00
#$ -N NTL
#$ -j y
#$ -m abe
#$ -M heromiya@hotmail.com

#rm -f qsub.log.d/qsub_exec.sh.log
#rm -f $LOG

#echo "### $(date +'%F_%T')" >> $LOG
. /etc/profile.d/modules.sh
#module load intel cuda/9.0.176 nccl/2.4.2 cudnn/7.4 tensorflow/1.12.0
. /home/7/17IA0902/miniconda3/etc/profile.d/conda.sh

export PATH=/home/7/17IA0902/miniconda3/bin/:$PATH
#export PATH=/home/7/17IA0902/apps/bin:$PATH
#export LD_LIBRARY_PATH=/home/7/17IA0902/apps/lib
export PROJ_LIB=/gs/hs0/tgh-20IAV/miyazaki/proj

export INPUT_TILES=$(echo h{29..30}v{07..08})

export PERIOD_2019=$(echo {329..365})
export TIMES_2019=11

export PERIOD_2020=$(echo {1..282})
export TIMES_2020=$(echo {0..8})

export DAYNUM=30

bash -x getNTL.sh
bash -x cal_median.sh
bash -x buildTimeSeries.sh


#INPUT_TILES="`h2{7..8}v07` h10v04 h29v05 h19v04 h13v11 h17v04 h10v05 h08v04"
#INPUT_TILES="h31v05 h32v05"
