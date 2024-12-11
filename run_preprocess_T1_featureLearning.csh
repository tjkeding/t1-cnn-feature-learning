#!/bin/tcsh

# Preprocess T1 Data for Use with CNN Feature Learning
# Taylor Keding (keding@wisc.edu)

set rawPath = "/Volumes/Vol6/YouthPTSD/data/t1resiliency/allsubj/mri"
set scripts = "/Volumes/Vol6/YouthPTSD/scripts/tjk_scripts/python_ML/CNN-feature-learning"
set RENAME_FILES = 0
set SCALE_RESIDUALIZE = 1

# Rename the files to contain consistently subject IDs and suffixes
if ($RENAME_FILES == 1) then
    set fileList = `ls ${rawPath}/mwp1*`
    foreach currFile($fileList)

        # Remove the CAT prefix
        set noPrefix = `echo $currFile | awk '{print substr($0,59)}'`

        # Define qualifying prefixes
        set herringaTest = `echo $noPrefix | awk '{print substr($0,1,1)}'`
        set mcLaughlinTest = `echo $noPrefix | awk '{print substr($0,1,1)}'`
        set aceTest = `echo $noPrefix | awk '{print substr($0,1,3)}'`
        set apalTest = `echo $noPrefix | awk '{print substr($0,1,4)}'`
        set madTest = `echo $noPrefix | awk '{print substr($0,1,3)}'`

        # Test for Herringa cohort
        if ( ${herringaTest} == "_" ) then
            set subjID = `echo $noPrefix | awk '{print substr($0,2,3)}'`
            set newPrefix = "H_${subjID}"

        # Test for McLaughlin cohort
        else if ( ${mcLaughlinTest} == "1" ) then
            set subjID = `echo $noPrefix | awk '{print substr($0,1,4)}'`
            set newPrefix = "M_${subjID}"

        # Test for ACE cohort
        else if ( ${aceTest} == "ACE" ) then
            set newPrefix = `echo $noPrefix | awk '{print substr($0,1,7)}'`

        # Test for ACE cohort
        else if ( ${apalTest} == "aPAL" ) then
            set subjID = `echo $noPrefix | awk '{print substr($0,6,3)}'`
            set newPrefix = "aPAL_${subjID}"

        # Test for MAD cohort
        else if ( ${madTest} == "MAD" ) then
            set newPrefix = `echo $noPrefix | awk '{print substr($0,1,7)}'`

        # Test for PTO cohort
        else
            set newPrefix = `echo $noPrefix | awk '{print substr($0,1,7)}'`
        endif

        mv ${rawPath}/mwp1${noPrefix} ${rawPath}/${newPrefix}_anat_CAT_GMV_noSmooth.nii
        gzip ${rawPath}/${newPrefix}_anat_CAT_GMV_noSmooth.nii
    end
endif

# For each subject, scale 
if ($SCALE_RESIDUALIZE == 1) then
    if (! -d ${rawPath}/CNN_featureLearning_proc) then
        mkdir ${rawPath}/CNN_featureLearning_proc
    endif

    python3 preprocess_T1_featureLearning.py ${scripts}/HCM_BrainnetomeAtlasExtract_unsmoothed.csv 0

    if (! -e ${rawPath}/CNN_featureLearning_proc/GMV_noSmooth_scaledTIV_resids.nii.gz) then
        # 3dtest++ table:
        3dttest++ -setA subjs \
            ACE_001 ${rawPath}/CNN_featureLearning_proc/ACE_001_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_004 ${rawPath}/CNN_featureLearning_proc/ACE_004_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_005 ${rawPath}/CNN_featureLearning_proc/ACE_005_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_006 ${rawPath}/CNN_featureLearning_proc/ACE_006_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_007 ${rawPath}/CNN_featureLearning_proc/ACE_007_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_008 ${rawPath}/CNN_featureLearning_proc/ACE_008_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_009 ${rawPath}/CNN_featureLearning_proc/ACE_009_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_010 ${rawPath}/CNN_featureLearning_proc/ACE_010_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_011 ${rawPath}/CNN_featureLearning_proc/ACE_011_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_012 ${rawPath}/CNN_featureLearning_proc/ACE_012_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_013 ${rawPath}/CNN_featureLearning_proc/ACE_013_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_014 ${rawPath}/CNN_featureLearning_proc/ACE_014_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_015 ${rawPath}/CNN_featureLearning_proc/ACE_015_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_016 ${rawPath}/CNN_featureLearning_proc/ACE_016_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_017 ${rawPath}/CNN_featureLearning_proc/ACE_017_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_018 ${rawPath}/CNN_featureLearning_proc/ACE_018_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_019 ${rawPath}/CNN_featureLearning_proc/ACE_019_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_021 ${rawPath}/CNN_featureLearning_proc/ACE_021_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_022 ${rawPath}/CNN_featureLearning_proc/ACE_022_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_023 ${rawPath}/CNN_featureLearning_proc/ACE_023_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_024 ${rawPath}/CNN_featureLearning_proc/ACE_024_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_025 ${rawPath}/CNN_featureLearning_proc/ACE_025_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_026 ${rawPath}/CNN_featureLearning_proc/ACE_026_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_027 ${rawPath}/CNN_featureLearning_proc/ACE_027_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_028 ${rawPath}/CNN_featureLearning_proc/ACE_028_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_029 ${rawPath}/CNN_featureLearning_proc/ACE_029_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_031 ${rawPath}/CNN_featureLearning_proc/ACE_031_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_032 ${rawPath}/CNN_featureLearning_proc/ACE_032_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_033 ${rawPath}/CNN_featureLearning_proc/ACE_033_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_034 ${rawPath}/CNN_featureLearning_proc/ACE_034_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_035 ${rawPath}/CNN_featureLearning_proc/ACE_035_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            ACE_037 ${rawPath}/CNN_featureLearning_proc/ACE_037_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_001 ${rawPath}/CNN_featureLearning_proc/aPAL_001_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_002 ${rawPath}/CNN_featureLearning_proc/aPAL_002_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_004 ${rawPath}/CNN_featureLearning_proc/aPAL_004_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_005 ${rawPath}/CNN_featureLearning_proc/aPAL_005_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_008 ${rawPath}/CNN_featureLearning_proc/aPAL_008_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_009 ${rawPath}/CNN_featureLearning_proc/aPAL_009_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_010 ${rawPath}/CNN_featureLearning_proc/aPAL_010_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_011 ${rawPath}/CNN_featureLearning_proc/aPAL_011_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_012 ${rawPath}/CNN_featureLearning_proc/aPAL_012_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_014 ${rawPath}/CNN_featureLearning_proc/aPAL_014_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_015 ${rawPath}/CNN_featureLearning_proc/aPAL_015_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_016 ${rawPath}/CNN_featureLearning_proc/aPAL_016_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_017 ${rawPath}/CNN_featureLearning_proc/aPAL_017_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_018 ${rawPath}/CNN_featureLearning_proc/aPAL_018_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_019 ${rawPath}/CNN_featureLearning_proc/aPAL_019_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_020 ${rawPath}/CNN_featureLearning_proc/aPAL_020_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_021 ${rawPath}/CNN_featureLearning_proc/aPAL_021_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_022 ${rawPath}/CNN_featureLearning_proc/aPAL_022_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_023 ${rawPath}/CNN_featureLearning_proc/aPAL_023_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_024 ${rawPath}/CNN_featureLearning_proc/aPAL_024_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_025 ${rawPath}/CNN_featureLearning_proc/aPAL_025_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_026 ${rawPath}/CNN_featureLearning_proc/aPAL_026_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_027 ${rawPath}/CNN_featureLearning_proc/aPAL_027_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_028 ${rawPath}/CNN_featureLearning_proc/aPAL_028_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_030 ${rawPath}/CNN_featureLearning_proc/aPAL_030_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_034 ${rawPath}/CNN_featureLearning_proc/aPAL_034_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_035 ${rawPath}/CNN_featureLearning_proc/aPAL_035_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_036 ${rawPath}/CNN_featureLearning_proc/aPAL_036_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_037 ${rawPath}/CNN_featureLearning_proc/aPAL_037_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_038 ${rawPath}/CNN_featureLearning_proc/aPAL_038_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_039 ${rawPath}/CNN_featureLearning_proc/aPAL_039_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_040 ${rawPath}/CNN_featureLearning_proc/aPAL_040_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_041 ${rawPath}/CNN_featureLearning_proc/aPAL_041_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_043 ${rawPath}/CNN_featureLearning_proc/aPAL_043_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_044 ${rawPath}/CNN_featureLearning_proc/aPAL_044_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_045 ${rawPath}/CNN_featureLearning_proc/aPAL_045_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_046 ${rawPath}/CNN_featureLearning_proc/aPAL_046_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_047 ${rawPath}/CNN_featureLearning_proc/aPAL_047_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_048 ${rawPath}/CNN_featureLearning_proc/aPAL_048_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_050 ${rawPath}/CNN_featureLearning_proc/aPAL_050_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_052 ${rawPath}/CNN_featureLearning_proc/aPAL_052_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_053 ${rawPath}/CNN_featureLearning_proc/aPAL_053_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_054 ${rawPath}/CNN_featureLearning_proc/aPAL_054_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_055 ${rawPath}/CNN_featureLearning_proc/aPAL_055_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_056 ${rawPath}/CNN_featureLearning_proc/aPAL_056_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_058 ${rawPath}/CNN_featureLearning_proc/aPAL_058_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_059 ${rawPath}/CNN_featureLearning_proc/aPAL_059_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_063 ${rawPath}/CNN_featureLearning_proc/aPAL_063_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_064 ${rawPath}/CNN_featureLearning_proc/aPAL_064_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_066 ${rawPath}/CNN_featureLearning_proc/aPAL_066_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            aPAL_067 ${rawPath}/CNN_featureLearning_proc/aPAL_067_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_013 ${rawPath}/CNN_featureLearning_proc/H_013_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_026 ${rawPath}/CNN_featureLearning_proc/H_026_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_029 ${rawPath}/CNN_featureLearning_proc/H_029_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_031 ${rawPath}/CNN_featureLearning_proc/H_031_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_043 ${rawPath}/CNN_featureLearning_proc/H_043_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_045 ${rawPath}/CNN_featureLearning_proc/H_045_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_057 ${rawPath}/CNN_featureLearning_proc/H_057_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_058 ${rawPath}/CNN_featureLearning_proc/H_058_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_059 ${rawPath}/CNN_featureLearning_proc/H_059_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_060 ${rawPath}/CNN_featureLearning_proc/H_060_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_061 ${rawPath}/CNN_featureLearning_proc/H_061_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_071 ${rawPath}/CNN_featureLearning_proc/H_071_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_073 ${rawPath}/CNN_featureLearning_proc/H_073_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_075 ${rawPath}/CNN_featureLearning_proc/H_075_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_078 ${rawPath}/CNN_featureLearning_proc/H_078_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_079 ${rawPath}/CNN_featureLearning_proc/H_079_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_082 ${rawPath}/CNN_featureLearning_proc/H_082_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_085 ${rawPath}/CNN_featureLearning_proc/H_085_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_086 ${rawPath}/CNN_featureLearning_proc/H_086_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_087 ${rawPath}/CNN_featureLearning_proc/H_087_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_089 ${rawPath}/CNN_featureLearning_proc/H_089_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_092 ${rawPath}/CNN_featureLearning_proc/H_092_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_093 ${rawPath}/CNN_featureLearning_proc/H_093_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_094 ${rawPath}/CNN_featureLearning_proc/H_094_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_097 ${rawPath}/CNN_featureLearning_proc/H_097_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_099 ${rawPath}/CNN_featureLearning_proc/H_099_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_100 ${rawPath}/CNN_featureLearning_proc/H_100_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_104 ${rawPath}/CNN_featureLearning_proc/H_104_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_112 ${rawPath}/CNN_featureLearning_proc/H_112_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_117 ${rawPath}/CNN_featureLearning_proc/H_117_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_122 ${rawPath}/CNN_featureLearning_proc/H_122_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_124 ${rawPath}/CNN_featureLearning_proc/H_124_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_125 ${rawPath}/CNN_featureLearning_proc/H_125_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_127 ${rawPath}/CNN_featureLearning_proc/H_127_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_128 ${rawPath}/CNN_featureLearning_proc/H_128_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_132 ${rawPath}/CNN_featureLearning_proc/H_132_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_133 ${rawPath}/CNN_featureLearning_proc/H_133_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_134 ${rawPath}/CNN_featureLearning_proc/H_134_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_138 ${rawPath}/CNN_featureLearning_proc/H_138_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_139 ${rawPath}/CNN_featureLearning_proc/H_139_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_142 ${rawPath}/CNN_featureLearning_proc/H_142_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_145 ${rawPath}/CNN_featureLearning_proc/H_145_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_148 ${rawPath}/CNN_featureLearning_proc/H_148_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_149 ${rawPath}/CNN_featureLearning_proc/H_149_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_154 ${rawPath}/CNN_featureLearning_proc/H_154_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            H_156 ${rawPath}/CNN_featureLearning_proc/H_156_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1002 ${rawPath}/CNN_featureLearning_proc/M_1002_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1004 ${rawPath}/CNN_featureLearning_proc/M_1004_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1005 ${rawPath}/CNN_featureLearning_proc/M_1005_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1006 ${rawPath}/CNN_featureLearning_proc/M_1006_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1007 ${rawPath}/CNN_featureLearning_proc/M_1007_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1008 ${rawPath}/CNN_featureLearning_proc/M_1008_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1009 ${rawPath}/CNN_featureLearning_proc/M_1009_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1011 ${rawPath}/CNN_featureLearning_proc/M_1011_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1014 ${rawPath}/CNN_featureLearning_proc/M_1014_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1015 ${rawPath}/CNN_featureLearning_proc/M_1015_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1019 ${rawPath}/CNN_featureLearning_proc/M_1019_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1030 ${rawPath}/CNN_featureLearning_proc/M_1030_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1032 ${rawPath}/CNN_featureLearning_proc/M_1032_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1037 ${rawPath}/CNN_featureLearning_proc/M_1037_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1038 ${rawPath}/CNN_featureLearning_proc/M_1038_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1043 ${rawPath}/CNN_featureLearning_proc/M_1043_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1045 ${rawPath}/CNN_featureLearning_proc/M_1045_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1047 ${rawPath}/CNN_featureLearning_proc/M_1047_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1048 ${rawPath}/CNN_featureLearning_proc/M_1048_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1049 ${rawPath}/CNN_featureLearning_proc/M_1049_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1050 ${rawPath}/CNN_featureLearning_proc/M_1050_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1056 ${rawPath}/CNN_featureLearning_proc/M_1056_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1063 ${rawPath}/CNN_featureLearning_proc/M_1063_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1077 ${rawPath}/CNN_featureLearning_proc/M_1077_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1090 ${rawPath}/CNN_featureLearning_proc/M_1090_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1091 ${rawPath}/CNN_featureLearning_proc/M_1091_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1092 ${rawPath}/CNN_featureLearning_proc/M_1092_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1098 ${rawPath}/CNN_featureLearning_proc/M_1098_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1105 ${rawPath}/CNN_featureLearning_proc/M_1105_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1106 ${rawPath}/CNN_featureLearning_proc/M_1106_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1113 ${rawPath}/CNN_featureLearning_proc/M_1113_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1115 ${rawPath}/CNN_featureLearning_proc/M_1115_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1117 ${rawPath}/CNN_featureLearning_proc/M_1117_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1124 ${rawPath}/CNN_featureLearning_proc/M_1124_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1125 ${rawPath}/CNN_featureLearning_proc/M_1125_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1128 ${rawPath}/CNN_featureLearning_proc/M_1128_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1133 ${rawPath}/CNN_featureLearning_proc/M_1133_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1139 ${rawPath}/CNN_featureLearning_proc/M_1139_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1142 ${rawPath}/CNN_featureLearning_proc/M_1142_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1148 ${rawPath}/CNN_featureLearning_proc/M_1148_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1150 ${rawPath}/CNN_featureLearning_proc/M_1150_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1152 ${rawPath}/CNN_featureLearning_proc/M_1152_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1153 ${rawPath}/CNN_featureLearning_proc/M_1153_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1154 ${rawPath}/CNN_featureLearning_proc/M_1154_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1158 ${rawPath}/CNN_featureLearning_proc/M_1158_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1159 ${rawPath}/CNN_featureLearning_proc/M_1159_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1162 ${rawPath}/CNN_featureLearning_proc/M_1162_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1168 ${rawPath}/CNN_featureLearning_proc/M_1168_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1173 ${rawPath}/CNN_featureLearning_proc/M_1173_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1175 ${rawPath}/CNN_featureLearning_proc/M_1175_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1176 ${rawPath}/CNN_featureLearning_proc/M_1176_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1178 ${rawPath}/CNN_featureLearning_proc/M_1178_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1180 ${rawPath}/CNN_featureLearning_proc/M_1180_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1182 ${rawPath}/CNN_featureLearning_proc/M_1182_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1184 ${rawPath}/CNN_featureLearning_proc/M_1184_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1191 ${rawPath}/CNN_featureLearning_proc/M_1191_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1195 ${rawPath}/CNN_featureLearning_proc/M_1195_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1197 ${rawPath}/CNN_featureLearning_proc/M_1197_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1198 ${rawPath}/CNN_featureLearning_proc/M_1198_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1199 ${rawPath}/CNN_featureLearning_proc/M_1199_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1200 ${rawPath}/CNN_featureLearning_proc/M_1200_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1203 ${rawPath}/CNN_featureLearning_proc/M_1203_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1208 ${rawPath}/CNN_featureLearning_proc/M_1208_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1215 ${rawPath}/CNN_featureLearning_proc/M_1215_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1218 ${rawPath}/CNN_featureLearning_proc/M_1218_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1219 ${rawPath}/CNN_featureLearning_proc/M_1219_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1223 ${rawPath}/CNN_featureLearning_proc/M_1223_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1226 ${rawPath}/CNN_featureLearning_proc/M_1226_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1232 ${rawPath}/CNN_featureLearning_proc/M_1232_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1237 ${rawPath}/CNN_featureLearning_proc/M_1237_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1240 ${rawPath}/CNN_featureLearning_proc/M_1240_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1245 ${rawPath}/CNN_featureLearning_proc/M_1245_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1246 ${rawPath}/CNN_featureLearning_proc/M_1246_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1248 ${rawPath}/CNN_featureLearning_proc/M_1248_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1250 ${rawPath}/CNN_featureLearning_proc/M_1250_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1254 ${rawPath}/CNN_featureLearning_proc/M_1254_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            M_1262 ${rawPath}/CNN_featureLearning_proc/M_1262_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            MAD_002 ${rawPath}/CNN_featureLearning_proc/MAD_002_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            MAD_003 ${rawPath}/CNN_featureLearning_proc/MAD_003_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            MAD_005 ${rawPath}/CNN_featureLearning_proc/MAD_005_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            MAD_006 ${rawPath}/CNN_featureLearning_proc/MAD_006_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            MAD_010 ${rawPath}/CNN_featureLearning_proc/MAD_010_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            MAD_011 ${rawPath}/CNN_featureLearning_proc/MAD_011_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            MAD_015 ${rawPath}/CNN_featureLearning_proc/MAD_015_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            MAD_016 ${rawPath}/CNN_featureLearning_proc/MAD_016_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            MAD_018 ${rawPath}/CNN_featureLearning_proc/MAD_018_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_001 ${rawPath}/CNN_featureLearning_proc/PTO_001_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_002 ${rawPath}/CNN_featureLearning_proc/PTO_002_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_003 ${rawPath}/CNN_featureLearning_proc/PTO_003_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_004 ${rawPath}/CNN_featureLearning_proc/PTO_004_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_005 ${rawPath}/CNN_featureLearning_proc/PTO_005_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_006 ${rawPath}/CNN_featureLearning_proc/PTO_006_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_007 ${rawPath}/CNN_featureLearning_proc/PTO_007_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_008 ${rawPath}/CNN_featureLearning_proc/PTO_008_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_009 ${rawPath}/CNN_featureLearning_proc/PTO_009_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_010 ${rawPath}/CNN_featureLearning_proc/PTO_010_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_012 ${rawPath}/CNN_featureLearning_proc/PTO_012_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_013 ${rawPath}/CNN_featureLearning_proc/PTO_013_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_015 ${rawPath}/CNN_featureLearning_proc/PTO_015_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_016 ${rawPath}/CNN_featureLearning_proc/PTO_016_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_017 ${rawPath}/CNN_featureLearning_proc/PTO_017_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_018 ${rawPath}/CNN_featureLearning_proc/PTO_018_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_019 ${rawPath}/CNN_featureLearning_proc/PTO_019_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_020 ${rawPath}/CNN_featureLearning_proc/PTO_020_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_021 ${rawPath}/CNN_featureLearning_proc/PTO_021_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_024 ${rawPath}/CNN_featureLearning_proc/PTO_024_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_027 ${rawPath}/CNN_featureLearning_proc/PTO_027_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_028 ${rawPath}/CNN_featureLearning_proc/PTO_028_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_029 ${rawPath}/CNN_featureLearning_proc/PTO_029_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_030 ${rawPath}/CNN_featureLearning_proc/PTO_030_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_031 ${rawPath}/CNN_featureLearning_proc/PTO_031_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_032 ${rawPath}/CNN_featureLearning_proc/PTO_032_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_034 ${rawPath}/CNN_featureLearning_proc/PTO_034_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_035 ${rawPath}/CNN_featureLearning_proc/PTO_035_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_036 ${rawPath}/CNN_featureLearning_proc/PTO_036_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_038 ${rawPath}/CNN_featureLearning_proc/PTO_038_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            PTO_039 ${rawPath}/CNN_featureLearning_proc/PTO_039_anat_CAT_GMV_noSmooth_scaledTIV.nii.gz \
            -covariates ${scripts}/scannerResidsCovariates.txt \
            -resid ${rawPath}/CNN_featureLearning_proc/GMV_noSmooth_scaledTIV_resids.nii.gz \
            -prefix ${rawPath}/CNN_featureLearning_proc/GMV_noSmooth_scaledTIV_stats.nii.gz
    endif

    python3 preprocess_T1_featureLearning.py ${scripts}/HCM_BrainnetomeAtlasExtract_unsmoothed.csv 1

    rm -f ${rawPath}/MEAN*
    rm -f ${rawPath}/SD*
    rm -f ${rawPath}/CNN_featureLearning_proc/MEAN*
    rm -f ${rawPath}/CNN_featureLearning_proc/SD*

    # Get voxel-wise mean map
    3dMean -prefix ${rawPath}/CNN_featureLearning_proc/MEAN_CAT_GMV_noSmooth_scaledTIV_residScanner.nii.gz \
        ${rawPath}/CNN_featureLearning_proc/*anat_CAT_GMV_noSmooth_scaledTIV_residScanner.nii.gz

    # Get voxel-wise SD map
    3dMean -sd -prefix ${rawPath}/CNN_featureLearning_proc/SD_CAT_GMV_noSmooth_scaledTIV_residScanner.nii.gz \
        ${rawPath}/CNN_featureLearning_proc/*anat_CAT_GMV_noSmooth_scaledTIV_residScanner.nii.gz

    python3 preprocess_T1_featureLearning.py ${scripts}/HCM_BrainnetomeAtlasExtract_unsmoothed.csv 2

    # THIS CODE IS NO LONGER NEEDED! (integrated the scan trimming to the feature learning code)
    # python3 preprocess_T1_featureLearning.py ${scripts}/HCM_BrainnetomeAtlasExtract_unsmoothed.csv 3

endif