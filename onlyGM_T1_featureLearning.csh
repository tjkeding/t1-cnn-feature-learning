#!/bin/tcsh

# Preprocess T1 Data for Use with CNN Feature Learning
# Taylor Keding (keding@wisc.edu)

set rawPath = "/Volumes/Vol6/YouthPTSD/data/t1resiliency/allsubj/mri/CNN_featureLearning_proc"
set scripts = "/Volumes/Vol6/YouthPTSD/scripts/tjk_scripts/python_ML/CNN-feature-learning"
foreach ID (`cat ${scripts}/allSubjs.csv`)
    rm -f "${rawPath}/${ID}_anat_CAT_GMV_noSmooth_scaledTIV_residScanner_std_gm.nii.gz"
    3dcalc -a "${rawPath}/${ID}_anat_CAT_GMV_noSmooth_scaledTIV_residScanner_std.nii.gz" \
        -b "${rawPath}/MNI152_T1_1.5mm_gm_resamp_dilate.nii.gz" -expr 'a*b' \
        -prefix "${rawPath}/${ID}_anat_CAT_GMV_noSmooth_scaledTIV_residScanner_std_gm.nii.gz"
end