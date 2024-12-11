#!/bin/tcsh

# RUN FEATURE LEARNING CNN MODEL
# Taylor Keding (keding@wisc.edu)

# Define directory
set gmvData = "/Volumes/Vol6/YouthPTSD/data/t1resiliency/allsubj/mri/CNN_featureLearning_proc"
set scripts = "/Volumes/Vol6/YouthPTSD/scripts/tjk_scripts/python_ML/CNN-feature-learning"
set toPredict = "PSYCH"
set label = "PSYCH"

# FOR REFERENCE:
# python3 cnn-feature-learning.py <dataFile> <mapFileDir> <prefix> <dvLabel>
#        <kCV_MB> <numSamp_MB> <numSamp_evalFI> <numCores_MB> <numCores_evalFI>
#docker run --gpus all -it --rm tensorflow/tensorflow:latest-gpu \
python3 cnn-feature-learning.py \
    "${scripts}/${toPredict}.csv" "${gmvData}" \
    "${gmvData}/out" "${label}" 10 300 1000 1 50