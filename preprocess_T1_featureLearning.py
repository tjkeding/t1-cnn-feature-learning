#!/usr/bin/python3
# coding: utf-8

# =======================================================================================================================
# PREPROCESS T1 GMV DATA FOR CNN FEATURE LEARNING
# Written by Taylor J. Keding (tjkeding@gmail.com)
# Last Updated: 08.17.20
# =======================================================================================================================
# -----------------------------------------------------------------------------------------------------------------------
# IMPORTS:
# -----------------------------------------------------------------------------------------------------------------------
# ---------- STOP ALL WARNINGS ----------
def warn(*args, **kwargs):
    pass
import warnings
warnings.warn = warn
# ---------------------------------------
# Python:
import sys
import string
import os
import csv
import subprocess

# Numpy:
import numpy as np

# Pandas:
import pandas as pd

# Nibabel
import nibabel as nib

# -----------------------------------------------------------------------------------------------------------------------
# MAIN:
# -----------------------------------------------------------------------------------------------------------------------

# Get data in a Pandas dataframe
DF = pd.read_csv(sys.argv[1])
trimDF = DF[DF.columns[0:7]]
choice = str(sys.argv[2])

# Define paths
rawData = "/Volumes/Vol6/YouthPTSD/data/t1resiliency/allsubj/mri"
scaledData = f"{rawData}/CNN_featureLearning_proc"
scripts = f"/Volumes/Vol6/YouthPTSD/scripts/tjk_scripts/python_ML/CNN-feature-learning"

if choice == "0":

    # Iterate subjects
    for i, subj in enumerate(trimDF['SUBJ']):

        # If the scaled map doesn't exist, scale the GMV map to TIV
        prefix = f"{scaledData}/{subj}_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz"
        if not os.path.exists(prefix):
            TIV = trimDF['TIV'][i]
            currFile = f"{rawData}/{subj}_anat_CAT_GMV_noSmooth.nii.gz"
            expr = f"a/{TIV}"
            subprocess.run(['3dcalc', '-a', currFile, '-expr', expr, '-prefix', prefix])

    # Create covariates file for 3dttest++
    if not os.path.exists(f"{scripts}/scannerResidsCovariates.txt"):
        oneHotDF = pd.get_dummies(trimDF.SCANNER,prefix='SCANNER')
        outDF = pd.concat([trimDF['SUBJ'],oneHotDF], axis=1)
        new_columns = outDF.columns.values
        new_columns[0] = "subject"
        outDF.columns  = new_columns
        outDF.to_csv(f"{scripts}/scannerResidsCovariates.txt",sep='\t',index=False)

elif choice == "1":
    # Iterate subjects
    for i, subj in enumerate(trimDF['SUBJ']):
        # If the residual map doesn't exist for this subject, create it
        allResids = f"{scaledData}/GMV_noSmooth_scaledTIV_resids.nii.gz[{i}]"
        prefix = f"{scaledData}/{subj}_anat_CAT_GMV_noSmooth_scaledTIV_residScanner.nii.gz"
        if not os.path.exists(prefix):
            subprocess.run(['3dcalc', '-a', allResids, '-expr', 'a', '-prefix', prefix])

elif choice == "2":
    # Iterate subjects
    for i, subj in enumerate(trimDF['SUBJ']):
        # If the standardized residual map doesn't exist for this subject, create it
        baseDir = "/Volumes/Vol6/YouthPTSD/data/t1resiliency/allsubj/mri/CNN_featureLearning_proc"
        filePath = f"{baseDir}/{subj}_anat_CAT_GMV_noSmooth_scaledTIV_residScanner.nii.gz"
        outPath = f"{baseDir}/{subj}_anat_CAT_GMV_noSmooth_scaledTIV_residScanner_std.nii.gz"
        means = f"{baseDir}/MEAN_CAT_GMV_noSmooth_scaledTIV_residScanner.nii.gz"
        sds = f"{baseDir}/SD_CAT_GMV_noSmooth_scaledTIV_residScanner.nii.gz"
        if not os.path.exists(outPath):
            subprocess.run(['3dcalc', '-a', filePath, '-b', means, '-c', sds, '-expr', '(a-b)/c', '-prefix', outPath])