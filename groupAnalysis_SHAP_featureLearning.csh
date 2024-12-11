#!/bin/tcsh

# Group Analysis of SHAP Maps - CNN Feature Learning
# Taylor Keding (keding@wisc.edu)

set dvLabel = "PSYCH"
set rawPath = "/Volumes/Vol6/YouthPTSD/data/t1resiliency/allsubj/mri/CNN_featureLearning_proc/out/${dvLabel}/SHAP"
set covFile = "/Volumes/Vol6/YouthPTSD/scripts/tjk_scripts/python_ML/CNN-feature-learning/covariates_SHAP_wScanner.txt"
set gmMask =  "/Volumes/Vol6/YouthPTSD/data/t1resiliency/allsubj/mri/CNN_featureLearning_proc/MNI152_T1_1.5mm_gm_resamp_const1.nii.gz"
set cov = "wOutScan"
set MAKE_ALL_SUBJ_MAPS = 1
set DIFF_FROM_ZERO = 0
set MAKE_GROUP_MAPS = 0
set THRESH_MAPS = 0

if ($DIFF_FROM_ZERO == 1) then
    cd ${rawPath}
    rm -f ${rawPath}/clustSim_6mm/*
    3dttest++ -setA allSubjs \
        ACE_001 ${rawPath}/ACE_001_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_004 ${rawPath}/ACE_004_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_005 ${rawPath}/ACE_005_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_006 ${rawPath}/ACE_006_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_007 ${rawPath}/ACE_007_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_008 ${rawPath}/ACE_008_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_009 ${rawPath}/ACE_009_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_010 ${rawPath}/ACE_010_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_011 ${rawPath}/ACE_011_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_012 ${rawPath}/ACE_012_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_014 ${rawPath}/ACE_014_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_015 ${rawPath}/ACE_015_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_016 ${rawPath}/ACE_016_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_017 ${rawPath}/ACE_017_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_018 ${rawPath}/ACE_018_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_019 ${rawPath}/ACE_019_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_022 ${rawPath}/ACE_022_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_023 ${rawPath}/ACE_023_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_024 ${rawPath}/ACE_024_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_026 ${rawPath}/ACE_026_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_027 ${rawPath}/ACE_027_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_028 ${rawPath}/ACE_028_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_029 ${rawPath}/ACE_029_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_031 ${rawPath}/ACE_031_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_032 ${rawPath}/ACE_032_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_034 ${rawPath}/ACE_034_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_035 ${rawPath}/ACE_035_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_001 ${rawPath}/aPAL_001_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_002 ${rawPath}/aPAL_002_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_005 ${rawPath}/aPAL_005_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_008 ${rawPath}/aPAL_008_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_010 ${rawPath}/aPAL_010_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_011 ${rawPath}/aPAL_011_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_012 ${rawPath}/aPAL_012_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_015 ${rawPath}/aPAL_015_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_016 ${rawPath}/aPAL_016_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_017 ${rawPath}/aPAL_017_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_018 ${rawPath}/aPAL_018_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_020 ${rawPath}/aPAL_020_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_021 ${rawPath}/aPAL_021_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_023 ${rawPath}/aPAL_023_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_024 ${rawPath}/aPAL_024_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_025 ${rawPath}/aPAL_025_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_026 ${rawPath}/aPAL_026_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_027 ${rawPath}/aPAL_027_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_028 ${rawPath}/aPAL_028_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_030 ${rawPath}/aPAL_030_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_036 ${rawPath}/aPAL_036_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_037 ${rawPath}/aPAL_037_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_043 ${rawPath}/aPAL_043_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_045 ${rawPath}/aPAL_045_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_047 ${rawPath}/aPAL_047_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_050 ${rawPath}/aPAL_050_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_053 ${rawPath}/aPAL_053_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_054 ${rawPath}/aPAL_054_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_055 ${rawPath}/aPAL_055_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_056 ${rawPath}/aPAL_056_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_058 ${rawPath}/aPAL_058_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_059 ${rawPath}/aPAL_059_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_063 ${rawPath}/aPAL_063_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_064 ${rawPath}/aPAL_064_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_066 ${rawPath}/aPAL_066_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_013 ${rawPath}/H_013_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_043 ${rawPath}/H_043_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_057 ${rawPath}/H_057_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_058 ${rawPath}/H_058_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_059 ${rawPath}/H_059_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_060 ${rawPath}/H_060_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_061 ${rawPath}/H_061_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_071 ${rawPath}/H_071_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_085 ${rawPath}/H_085_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_087 ${rawPath}/H_087_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_089 ${rawPath}/H_089_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_092 ${rawPath}/H_092_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_093 ${rawPath}/H_093_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_094 ${rawPath}/H_094_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_097 ${rawPath}/H_097_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_099 ${rawPath}/H_099_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_100 ${rawPath}/H_100_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_112 ${rawPath}/H_112_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_117 ${rawPath}/H_117_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_125 ${rawPath}/H_125_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_128 ${rawPath}/H_128_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_134 ${rawPath}/H_134_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_142 ${rawPath}/H_142_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_145 ${rawPath}/H_145_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_148 ${rawPath}/H_148_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_149 ${rawPath}/H_149_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_156 ${rawPath}/H_156_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1004 ${rawPath}/M_1004_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1005 ${rawPath}/M_1005_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1006 ${rawPath}/M_1006_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1007 ${rawPath}/M_1007_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1008 ${rawPath}/M_1008_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1011 ${rawPath}/M_1011_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1015 ${rawPath}/M_1015_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1019 ${rawPath}/M_1019_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1030 ${rawPath}/M_1030_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1032 ${rawPath}/M_1032_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1043 ${rawPath}/M_1043_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1045 ${rawPath}/M_1045_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1047 ${rawPath}/M_1047_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1048 ${rawPath}/M_1048_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1049 ${rawPath}/M_1049_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1050 ${rawPath}/M_1050_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1056 ${rawPath}/M_1056_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1063 ${rawPath}/M_1063_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1077 ${rawPath}/M_1077_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1091 ${rawPath}/M_1091_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1092 ${rawPath}/M_1092_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1098 ${rawPath}/M_1098_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1105 ${rawPath}/M_1105_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1106 ${rawPath}/M_1106_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1115 ${rawPath}/M_1115_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1128 ${rawPath}/M_1128_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1133 ${rawPath}/M_1133_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1152 ${rawPath}/M_1152_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1153 ${rawPath}/M_1153_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1173 ${rawPath}/M_1173_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1175 ${rawPath}/M_1175_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1176 ${rawPath}/M_1176_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1191 ${rawPath}/M_1191_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1197 ${rawPath}/M_1197_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1198 ${rawPath}/M_1198_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1199 ${rawPath}/M_1199_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1200 ${rawPath}/M_1200_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1208 ${rawPath}/M_1208_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1215 ${rawPath}/M_1215_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1218 ${rawPath}/M_1218_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1219 ${rawPath}/M_1219_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1223 ${rawPath}/M_1223_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1226 ${rawPath}/M_1226_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1232 ${rawPath}/M_1232_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1237 ${rawPath}/M_1237_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1240 ${rawPath}/M_1240_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1245 ${rawPath}/M_1245_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1246 ${rawPath}/M_1246_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1248 ${rawPath}/M_1248_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1250 ${rawPath}/M_1250_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1262 ${rawPath}/M_1262_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        MAD_002 ${rawPath}/MAD_002_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        MAD_003 ${rawPath}/MAD_003_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        MAD_005 ${rawPath}/MAD_005_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        MAD_006 ${rawPath}/MAD_006_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        MAD_010 ${rawPath}/MAD_010_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        MAD_011 ${rawPath}/MAD_011_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        MAD_015 ${rawPath}/MAD_015_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        MAD_016 ${rawPath}/MAD_016_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        MAD_018 ${rawPath}/MAD_018_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_013 ${rawPath}/ACE_013_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_021 ${rawPath}/ACE_021_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_025 ${rawPath}/ACE_025_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_033 ${rawPath}/ACE_033_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        ACE_037 ${rawPath}/ACE_037_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_004 ${rawPath}/aPAL_004_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_009 ${rawPath}/aPAL_009_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_014 ${rawPath}/aPAL_014_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_019 ${rawPath}/aPAL_019_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_022 ${rawPath}/aPAL_022_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_034 ${rawPath}/aPAL_034_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_035 ${rawPath}/aPAL_035_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_038 ${rawPath}/aPAL_038_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_039 ${rawPath}/aPAL_039_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_040 ${rawPath}/aPAL_040_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_041 ${rawPath}/aPAL_041_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_044 ${rawPath}/aPAL_044_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_046 ${rawPath}/aPAL_046_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_048 ${rawPath}/aPAL_048_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_052 ${rawPath}/aPAL_052_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        aPAL_067 ${rawPath}/aPAL_067_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_026 ${rawPath}/H_026_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_029 ${rawPath}/H_029_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_031 ${rawPath}/H_031_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_045 ${rawPath}/H_045_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_073 ${rawPath}/H_073_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_075 ${rawPath}/H_075_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_078 ${rawPath}/H_078_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_079 ${rawPath}/H_079_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_082 ${rawPath}/H_082_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_086 ${rawPath}/H_086_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_104 ${rawPath}/H_104_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_122 ${rawPath}/H_122_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_124 ${rawPath}/H_124_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_127 ${rawPath}/H_127_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_132 ${rawPath}/H_132_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_133 ${rawPath}/H_133_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_138 ${rawPath}/H_138_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_139 ${rawPath}/H_139_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        H_154 ${rawPath}/H_154_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1009 ${rawPath}/M_1009_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1014 ${rawPath}/M_1014_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1037 ${rawPath}/M_1037_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1038 ${rawPath}/M_1038_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1090 ${rawPath}/M_1090_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1113 ${rawPath}/M_1113_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1117 ${rawPath}/M_1117_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1124 ${rawPath}/M_1124_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1125 ${rawPath}/M_1125_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1139 ${rawPath}/M_1139_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1142 ${rawPath}/M_1142_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1148 ${rawPath}/M_1148_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1150 ${rawPath}/M_1150_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1154 ${rawPath}/M_1154_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1158 ${rawPath}/M_1158_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1159 ${rawPath}/M_1159_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1162 ${rawPath}/M_1162_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1168 ${rawPath}/M_1168_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1178 ${rawPath}/M_1178_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1180 ${rawPath}/M_1180_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1182 ${rawPath}/M_1182_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1184 ${rawPath}/M_1184_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1195 ${rawPath}/M_1195_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1203 ${rawPath}/M_1203_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        M_1254 ${rawPath}/M_1254_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_001 ${rawPath}/PTO_001_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_002 ${rawPath}/PTO_002_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_003 ${rawPath}/PTO_003_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_004 ${rawPath}/PTO_004_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_005 ${rawPath}/PTO_005_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_006 ${rawPath}/PTO_006_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_007 ${rawPath}/PTO_007_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_008 ${rawPath}/PTO_008_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_009 ${rawPath}/PTO_009_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_010 ${rawPath}/PTO_010_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_012 ${rawPath}/PTO_012_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_013 ${rawPath}/PTO_013_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_015 ${rawPath}/PTO_015_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_016 ${rawPath}/PTO_016_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_017 ${rawPath}/PTO_017_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_018 ${rawPath}/PTO_018_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_019 ${rawPath}/PTO_019_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_020 ${rawPath}/PTO_020_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_021 ${rawPath}/PTO_021_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_024 ${rawPath}/PTO_024_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_027 ${rawPath}/PTO_027_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_028 ${rawPath}/PTO_028_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_029 ${rawPath}/PTO_029_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_030 ${rawPath}/PTO_030_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_031 ${rawPath}/PTO_031_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_032 ${rawPath}/PTO_032_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_034 ${rawPath}/PTO_034_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_035 ${rawPath}/PTO_035_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_036 ${rawPath}/PTO_036_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_038 ${rawPath}/PTO_038_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        PTO_039 ${rawPath}/PTO_039_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
        -mask ${gmMask} -covariates ${covFile} \
        -Clustsim 25 -tempdir ${rawPath}/clustSim_6mm \
        -prefix_clustsim ttest_SHAP_1_${dvLabel}_blur6_abs_scaled_clustSim \
        -prefix ttest_SHAP_1_${dvLabel}_groupAll_blur6_abs_scaled

endif 

# Iterate through different smoothing kernels
foreach blur (6)
    if ($MAKE_ALL_SUBJ_MAPS == 1) then
        cd ${rawPath}
        3dMean -prefix mean_SHAP_1_${dvLabel}_allSubjs.nii.gz \
            ${rawPath}/ACE_001_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_004_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_005_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_006_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_007_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_008_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_009_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_010_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_011_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_012_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_014_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_015_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_016_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_017_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_018_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_019_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_022_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_023_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_024_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_026_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_027_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_028_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_029_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_031_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_032_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_034_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_035_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_001_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_002_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_005_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_008_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_010_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_011_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_012_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_015_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_016_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_017_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_018_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_020_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_021_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_023_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_024_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_025_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_026_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_027_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_028_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_030_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_036_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_037_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_043_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_045_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_047_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_050_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_053_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_054_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_055_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_056_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_058_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_059_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_063_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_064_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_066_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_013_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_043_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_057_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_058_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_059_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_060_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_061_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_071_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_085_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_087_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_089_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_092_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_093_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_094_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_097_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_099_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_100_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_112_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_117_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_125_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_128_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_134_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_142_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_145_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_148_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_149_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_156_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1004_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1005_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1006_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1007_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1008_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1011_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1015_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1019_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1030_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1032_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1043_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1045_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1047_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1048_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1049_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1050_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1056_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1063_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1077_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1091_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1092_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1098_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1105_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1106_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1115_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1128_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1133_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1152_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1153_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1173_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1175_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1176_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1191_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1197_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1198_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1199_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1200_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1208_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1215_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1218_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1219_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1223_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1226_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1232_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1237_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1240_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1245_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1246_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1248_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1250_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1262_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/MAD_002_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/MAD_003_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/MAD_005_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/MAD_006_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/MAD_010_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/MAD_011_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/MAD_015_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/MAD_016_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/MAD_018_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_013_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_021_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_025_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_033_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/ACE_037_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_004_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_009_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_014_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_019_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_022_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_034_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_035_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_038_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_039_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_040_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_041_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_044_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_046_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_048_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_052_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/aPAL_067_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_026_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_029_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_031_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_045_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_073_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_075_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_078_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_079_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_082_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_086_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_104_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_122_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_124_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_127_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_132_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_133_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_138_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_139_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/H_154_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1009_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1014_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1037_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1038_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1090_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1113_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1117_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1124_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1125_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1139_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1142_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1148_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1150_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1154_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1158_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1159_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1162_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1168_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1178_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1180_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1182_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1184_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1195_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1203_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/M_1254_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_001_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_002_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_003_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_004_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_005_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_006_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_007_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_008_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_009_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_010_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_012_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_013_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_015_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_016_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_017_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_018_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_019_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_020_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_021_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_024_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_027_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_028_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_029_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_030_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_031_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_032_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_034_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_035_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_036_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_038_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz \
            ${rawPath}/PTO_039_gradSHAP_${dvLabel}_1_blur6_abs_scaled.nii.gz
    endif

    if ($MAKE_GROUP_MAPS == 1) then
        if (${dvLabel} == "PSYCH") then
            # Labels as groups:
            rm -f ${rawPath}/*${dvLabel}_groupDiff_${blur}mm_${cov}*
            rm -f ${rawPath}/clustSim_${blur}mm/*
            cd ${rawPath}
            3dttest++ -setA noPsych \
                ACE_001 ${rawPath}/ACE_001_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_004 ${rawPath}/ACE_004_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_005 ${rawPath}/ACE_005_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_006 ${rawPath}/ACE_006_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_007 ${rawPath}/ACE_007_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_008 ${rawPath}/ACE_008_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_009 ${rawPath}/ACE_009_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_010 ${rawPath}/ACE_010_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_011 ${rawPath}/ACE_011_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_012 ${rawPath}/ACE_012_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_014 ${rawPath}/ACE_014_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_015 ${rawPath}/ACE_015_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_016 ${rawPath}/ACE_016_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_017 ${rawPath}/ACE_017_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_018 ${rawPath}/ACE_018_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_019 ${rawPath}/ACE_019_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_022 ${rawPath}/ACE_022_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_023 ${rawPath}/ACE_023_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_024 ${rawPath}/ACE_024_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_026 ${rawPath}/ACE_026_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_027 ${rawPath}/ACE_027_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_028 ${rawPath}/ACE_028_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_029 ${rawPath}/ACE_029_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_031 ${rawPath}/ACE_031_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_032 ${rawPath}/ACE_032_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_034 ${rawPath}/ACE_034_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_035 ${rawPath}/ACE_035_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_001 ${rawPath}/aPAL_001_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_002 ${rawPath}/aPAL_002_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_005 ${rawPath}/aPAL_005_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_008 ${rawPath}/aPAL_008_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_010 ${rawPath}/aPAL_010_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_011 ${rawPath}/aPAL_011_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_012 ${rawPath}/aPAL_012_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_015 ${rawPath}/aPAL_015_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_016 ${rawPath}/aPAL_016_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_017 ${rawPath}/aPAL_017_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_018 ${rawPath}/aPAL_018_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_020 ${rawPath}/aPAL_020_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_021 ${rawPath}/aPAL_021_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_023 ${rawPath}/aPAL_023_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_024 ${rawPath}/aPAL_024_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_025 ${rawPath}/aPAL_025_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_026 ${rawPath}/aPAL_026_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_027 ${rawPath}/aPAL_027_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_028 ${rawPath}/aPAL_028_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_030 ${rawPath}/aPAL_030_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_036 ${rawPath}/aPAL_036_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_037 ${rawPath}/aPAL_037_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_043 ${rawPath}/aPAL_043_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_045 ${rawPath}/aPAL_045_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_047 ${rawPath}/aPAL_047_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_050 ${rawPath}/aPAL_050_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_053 ${rawPath}/aPAL_053_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_054 ${rawPath}/aPAL_054_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_055 ${rawPath}/aPAL_055_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_056 ${rawPath}/aPAL_056_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_058 ${rawPath}/aPAL_058_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_059 ${rawPath}/aPAL_059_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_063 ${rawPath}/aPAL_063_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_064 ${rawPath}/aPAL_064_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_066 ${rawPath}/aPAL_066_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_013 ${rawPath}/H_013_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_043 ${rawPath}/H_043_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_057 ${rawPath}/H_057_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_058 ${rawPath}/H_058_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_059 ${rawPath}/H_059_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_060 ${rawPath}/H_060_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_061 ${rawPath}/H_061_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_071 ${rawPath}/H_071_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_085 ${rawPath}/H_085_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_087 ${rawPath}/H_087_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_089 ${rawPath}/H_089_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_092 ${rawPath}/H_092_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_093 ${rawPath}/H_093_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_094 ${rawPath}/H_094_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_097 ${rawPath}/H_097_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_099 ${rawPath}/H_099_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_100 ${rawPath}/H_100_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_112 ${rawPath}/H_112_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_117 ${rawPath}/H_117_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_125 ${rawPath}/H_125_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_128 ${rawPath}/H_128_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_134 ${rawPath}/H_134_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_142 ${rawPath}/H_142_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_145 ${rawPath}/H_145_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_148 ${rawPath}/H_148_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_149 ${rawPath}/H_149_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_156 ${rawPath}/H_156_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1004 ${rawPath}/M_1004_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1005 ${rawPath}/M_1005_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1006 ${rawPath}/M_1006_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1007 ${rawPath}/M_1007_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1008 ${rawPath}/M_1008_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1011 ${rawPath}/M_1011_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1015 ${rawPath}/M_1015_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1019 ${rawPath}/M_1019_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1030 ${rawPath}/M_1030_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1032 ${rawPath}/M_1032_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1043 ${rawPath}/M_1043_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1045 ${rawPath}/M_1045_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1047 ${rawPath}/M_1047_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1048 ${rawPath}/M_1048_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1049 ${rawPath}/M_1049_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1050 ${rawPath}/M_1050_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1056 ${rawPath}/M_1056_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1063 ${rawPath}/M_1063_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1077 ${rawPath}/M_1077_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1091 ${rawPath}/M_1091_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1092 ${rawPath}/M_1092_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1098 ${rawPath}/M_1098_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1105 ${rawPath}/M_1105_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1106 ${rawPath}/M_1106_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1115 ${rawPath}/M_1115_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1128 ${rawPath}/M_1128_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1133 ${rawPath}/M_1133_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1152 ${rawPath}/M_1152_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1153 ${rawPath}/M_1153_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1173 ${rawPath}/M_1173_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1175 ${rawPath}/M_1175_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1176 ${rawPath}/M_1176_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1191 ${rawPath}/M_1191_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1197 ${rawPath}/M_1197_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1198 ${rawPath}/M_1198_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1199 ${rawPath}/M_1199_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1200 ${rawPath}/M_1200_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1208 ${rawPath}/M_1208_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1215 ${rawPath}/M_1215_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1218 ${rawPath}/M_1218_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1219 ${rawPath}/M_1219_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1223 ${rawPath}/M_1223_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1226 ${rawPath}/M_1226_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1232 ${rawPath}/M_1232_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1237 ${rawPath}/M_1237_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1240 ${rawPath}/M_1240_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1245 ${rawPath}/M_1245_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1246 ${rawPath}/M_1246_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1248 ${rawPath}/M_1248_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1250 ${rawPath}/M_1250_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1262 ${rawPath}/M_1262_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                MAD_002 ${rawPath}/MAD_002_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                MAD_003 ${rawPath}/MAD_003_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                MAD_005 ${rawPath}/MAD_005_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                MAD_006 ${rawPath}/MAD_006_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                MAD_010 ${rawPath}/MAD_010_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                MAD_011 ${rawPath}/MAD_011_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                MAD_015 ${rawPath}/MAD_015_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                MAD_016 ${rawPath}/MAD_016_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                MAD_018 ${rawPath}/MAD_018_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                -setB psych \
                ACE_013 ${rawPath}/ACE_013_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_021 ${rawPath}/ACE_021_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_025 ${rawPath}/ACE_025_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_033 ${rawPath}/ACE_033_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_037 ${rawPath}/ACE_037_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_004 ${rawPath}/aPAL_004_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_009 ${rawPath}/aPAL_009_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_014 ${rawPath}/aPAL_014_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_019 ${rawPath}/aPAL_019_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_022 ${rawPath}/aPAL_022_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_034 ${rawPath}/aPAL_034_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_035 ${rawPath}/aPAL_035_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_038 ${rawPath}/aPAL_038_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_039 ${rawPath}/aPAL_039_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_040 ${rawPath}/aPAL_040_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_041 ${rawPath}/aPAL_041_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_044 ${rawPath}/aPAL_044_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_046 ${rawPath}/aPAL_046_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_048 ${rawPath}/aPAL_048_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_052 ${rawPath}/aPAL_052_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_067 ${rawPath}/aPAL_067_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_026 ${rawPath}/H_026_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_029 ${rawPath}/H_029_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_031 ${rawPath}/H_031_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_045 ${rawPath}/H_045_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_073 ${rawPath}/H_073_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_075 ${rawPath}/H_075_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_078 ${rawPath}/H_078_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_079 ${rawPath}/H_079_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_082 ${rawPath}/H_082_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_086 ${rawPath}/H_086_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_104 ${rawPath}/H_104_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_122 ${rawPath}/H_122_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_124 ${rawPath}/H_124_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_127 ${rawPath}/H_127_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_132 ${rawPath}/H_132_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_133 ${rawPath}/H_133_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_138 ${rawPath}/H_138_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_139 ${rawPath}/H_139_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_154 ${rawPath}/H_154_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1009 ${rawPath}/M_1009_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1014 ${rawPath}/M_1014_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1037 ${rawPath}/M_1037_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1038 ${rawPath}/M_1038_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1090 ${rawPath}/M_1090_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1113 ${rawPath}/M_1113_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1117 ${rawPath}/M_1117_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1124 ${rawPath}/M_1124_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1125 ${rawPath}/M_1125_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1139 ${rawPath}/M_1139_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1142 ${rawPath}/M_1142_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1148 ${rawPath}/M_1148_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1150 ${rawPath}/M_1150_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1154 ${rawPath}/M_1154_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1158 ${rawPath}/M_1158_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1159 ${rawPath}/M_1159_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1162 ${rawPath}/M_1162_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1168 ${rawPath}/M_1168_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1178 ${rawPath}/M_1178_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1180 ${rawPath}/M_1180_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1182 ${rawPath}/M_1182_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1184 ${rawPath}/M_1184_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1195 ${rawPath}/M_1195_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1203 ${rawPath}/M_1203_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1254 ${rawPath}/M_1254_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_001 ${rawPath}/PTO_001_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_002 ${rawPath}/PTO_002_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_003 ${rawPath}/PTO_003_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_004 ${rawPath}/PTO_004_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_005 ${rawPath}/PTO_005_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_006 ${rawPath}/PTO_006_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_007 ${rawPath}/PTO_007_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_008 ${rawPath}/PTO_008_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_009 ${rawPath}/PTO_009_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_010 ${rawPath}/PTO_010_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_012 ${rawPath}/PTO_012_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_013 ${rawPath}/PTO_013_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_015 ${rawPath}/PTO_015_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_016 ${rawPath}/PTO_016_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_017 ${rawPath}/PTO_017_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_018 ${rawPath}/PTO_018_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_019 ${rawPath}/PTO_019_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_020 ${rawPath}/PTO_020_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_021 ${rawPath}/PTO_021_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_024 ${rawPath}/PTO_024_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_027 ${rawPath}/PTO_027_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_028 ${rawPath}/PTO_028_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_029 ${rawPath}/PTO_029_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_030 ${rawPath}/PTO_030_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_031 ${rawPath}/PTO_031_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_032 ${rawPath}/PTO_032_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_034 ${rawPath}/PTO_034_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_035 ${rawPath}/PTO_035_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_036 ${rawPath}/PTO_036_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_038 ${rawPath}/PTO_038_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_039 ${rawPath}/PTO_039_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                -mask ${gmMask} \
                -covariates ${covFile} -center DIFF -exblur $blur \
                -Clustsim 25 -tempdir ${rawPath}/clustSim_${blur}mm \
                -prefix_clustsim ttest_SHAP_1_${dvLabel}_groupDiff_${blur}mm_${cov}_clustSim \
                -prefix ttest_SHAP_1_${dvLabel}_groupDiff_${blur}mm_${cov}
        endif

        if (${dvLabel} == "ABUSE") then
            # Labels as groups:
            rm -f ${rawPath}/*${dvLabel}_groupDiff_${blur}mm_${cov}*
            rm -f ${rawPath}/clustSim_${blur}mm/*
            cd ${rawPath}
            3dttest++ -setA noAbuse \
                ACE_004 ${rawPath}/ACE_004_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_005 ${rawPath}/ACE_005_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_006 ${rawPath}/ACE_006_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_011 ${rawPath}/ACE_011_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_017 ${rawPath}/ACE_017_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_019 ${rawPath}/ACE_019_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_021 ${rawPath}/ACE_021_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_022 ${rawPath}/ACE_022_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_023 ${rawPath}/ACE_023_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_027 ${rawPath}/ACE_027_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_029 ${rawPath}/ACE_029_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_034 ${rawPath}/ACE_034_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_035 ${rawPath}/ACE_035_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_010 ${rawPath}/aPAL_010_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_012 ${rawPath}/aPAL_012_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_017 ${rawPath}/aPAL_017_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_018 ${rawPath}/aPAL_018_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_021 ${rawPath}/aPAL_021_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_036 ${rawPath}/aPAL_036_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_037 ${rawPath}/aPAL_037_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_038 ${rawPath}/aPAL_038_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_043 ${rawPath}/aPAL_043_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_045 ${rawPath}/aPAL_045_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_047 ${rawPath}/aPAL_047_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_048 ${rawPath}/aPAL_048_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_050 ${rawPath}/aPAL_050_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_053 ${rawPath}/aPAL_053_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_054 ${rawPath}/aPAL_054_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_055 ${rawPath}/aPAL_055_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_056 ${rawPath}/aPAL_056_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_058 ${rawPath}/aPAL_058_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_059 ${rawPath}/aPAL_059_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_063 ${rawPath}/aPAL_063_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_064 ${rawPath}/aPAL_064_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_066 ${rawPath}/aPAL_066_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_013 ${rawPath}/H_013_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_043 ${rawPath}/H_043_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_057 ${rawPath}/H_057_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_058 ${rawPath}/H_058_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_060 ${rawPath}/H_060_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_061 ${rawPath}/H_061_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_071 ${rawPath}/H_071_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_085 ${rawPath}/H_085_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_087 ${rawPath}/H_087_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_089 ${rawPath}/H_089_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_092 ${rawPath}/H_092_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_093 ${rawPath}/H_093_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_097 ${rawPath}/H_097_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_100 ${rawPath}/H_100_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_125 ${rawPath}/H_125_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_128 ${rawPath}/H_128_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_134 ${rawPath}/H_134_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_142 ${rawPath}/H_142_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_145 ${rawPath}/H_145_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_148 ${rawPath}/H_148_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_149 ${rawPath}/H_149_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_156 ${rawPath}/H_156_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1002 ${rawPath}/M_1002_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1004 ${rawPath}/M_1004_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1005 ${rawPath}/M_1005_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1006 ${rawPath}/M_1006_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1007 ${rawPath}/M_1007_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1008 ${rawPath}/M_1008_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1011 ${rawPath}/M_1011_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1030 ${rawPath}/M_1030_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1032 ${rawPath}/M_1032_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1045 ${rawPath}/M_1045_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1047 ${rawPath}/M_1047_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1050 ${rawPath}/M_1050_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1063 ${rawPath}/M_1063_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1090 ${rawPath}/M_1090_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1091 ${rawPath}/M_1091_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1098 ${rawPath}/M_1098_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1105 ${rawPath}/M_1105_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1106 ${rawPath}/M_1106_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1113 ${rawPath}/M_1113_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1115 ${rawPath}/M_1115_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1117 ${rawPath}/M_1117_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1125 ${rawPath}/M_1125_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1128 ${rawPath}/M_1128_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1133 ${rawPath}/M_1133_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1142 ${rawPath}/M_1142_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1152 ${rawPath}/M_1152_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1153 ${rawPath}/M_1153_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1158 ${rawPath}/M_1158_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1173 ${rawPath}/M_1173_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1184 ${rawPath}/M_1184_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1195 ${rawPath}/M_1195_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1197 ${rawPath}/M_1197_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1198 ${rawPath}/M_1198_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1199 ${rawPath}/M_1199_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1218 ${rawPath}/M_1218_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1223 ${rawPath}/M_1223_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1226 ${rawPath}/M_1226_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1237 ${rawPath}/M_1237_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1240 ${rawPath}/M_1240_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1245 ${rawPath}/M_1245_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1246 ${rawPath}/M_1246_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1248 ${rawPath}/M_1248_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1250 ${rawPath}/M_1250_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1262 ${rawPath}/M_1262_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                MAD_002 ${rawPath}/MAD_002_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                MAD_003 ${rawPath}/MAD_003_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                MAD_005 ${rawPath}/MAD_005_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                MAD_006 ${rawPath}/MAD_006_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                MAD_010 ${rawPath}/MAD_010_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                MAD_011 ${rawPath}/MAD_011_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                MAD_015 ${rawPath}/MAD_015_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                MAD_016 ${rawPath}/MAD_016_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                MAD_018 ${rawPath}/MAD_018_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_010 ${rawPath}/PTO_010_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                -setB abuse \
                ACE_001 ${rawPath}/ACE_001_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_007 ${rawPath}/ACE_007_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_008 ${rawPath}/ACE_008_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_009 ${rawPath}/ACE_009_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_010 ${rawPath}/ACE_010_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_012 ${rawPath}/ACE_012_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_013 ${rawPath}/ACE_013_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_014 ${rawPath}/ACE_014_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_015 ${rawPath}/ACE_015_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_016 ${rawPath}/ACE_016_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_018 ${rawPath}/ACE_018_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_024 ${rawPath}/ACE_024_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_025 ${rawPath}/ACE_025_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_026 ${rawPath}/ACE_026_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_028 ${rawPath}/ACE_028_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_031 ${rawPath}/ACE_031_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_032 ${rawPath}/ACE_032_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_033 ${rawPath}/ACE_033_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                ACE_037 ${rawPath}/ACE_037_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_001 ${rawPath}/aPAL_001_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_002 ${rawPath}/aPAL_002_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_004 ${rawPath}/aPAL_004_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_005 ${rawPath}/aPAL_005_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_008 ${rawPath}/aPAL_008_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_009 ${rawPath}/aPAL_009_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_011 ${rawPath}/aPAL_011_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_014 ${rawPath}/aPAL_014_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_015 ${rawPath}/aPAL_015_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_016 ${rawPath}/aPAL_016_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_019 ${rawPath}/aPAL_019_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_020 ${rawPath}/aPAL_020_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_022 ${rawPath}/aPAL_022_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_023 ${rawPath}/aPAL_023_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_024 ${rawPath}/aPAL_024_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_025 ${rawPath}/aPAL_025_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_026 ${rawPath}/aPAL_026_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_027 ${rawPath}/aPAL_027_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_028 ${rawPath}/aPAL_028_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_030 ${rawPath}/aPAL_030_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_034 ${rawPath}/aPAL_034_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_035 ${rawPath}/aPAL_035_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_039 ${rawPath}/aPAL_039_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_040 ${rawPath}/aPAL_040_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_041 ${rawPath}/aPAL_041_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_044 ${rawPath}/aPAL_044_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_046 ${rawPath}/aPAL_046_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_052 ${rawPath}/aPAL_052_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                aPAL_067 ${rawPath}/aPAL_067_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_026 ${rawPath}/H_026_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_029 ${rawPath}/H_029_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_031 ${rawPath}/H_031_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_045 ${rawPath}/H_045_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_059 ${rawPath}/H_059_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_073 ${rawPath}/H_073_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_075 ${rawPath}/H_075_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_078 ${rawPath}/H_078_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_079 ${rawPath}/H_079_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_082 ${rawPath}/H_082_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_086 ${rawPath}/H_086_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_094 ${rawPath}/H_094_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_099 ${rawPath}/H_099_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_104 ${rawPath}/H_104_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_112 ${rawPath}/H_112_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_117 ${rawPath}/H_117_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_122 ${rawPath}/H_122_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_124 ${rawPath}/H_124_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_127 ${rawPath}/H_127_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_132 ${rawPath}/H_132_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_133 ${rawPath}/H_133_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_138 ${rawPath}/H_138_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_139 ${rawPath}/H_139_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                H_154 ${rawPath}/H_154_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1009 ${rawPath}/M_1009_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1014 ${rawPath}/M_1014_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1015 ${rawPath}/M_1015_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1019 ${rawPath}/M_1019_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1037 ${rawPath}/M_1037_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1038 ${rawPath}/M_1038_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1043 ${rawPath}/M_1043_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1048 ${rawPath}/M_1048_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1049 ${rawPath}/M_1049_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1056 ${rawPath}/M_1056_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1077 ${rawPath}/M_1077_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1092 ${rawPath}/M_1092_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1124 ${rawPath}/M_1124_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1139 ${rawPath}/M_1139_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1148 ${rawPath}/M_1148_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1150 ${rawPath}/M_1150_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1154 ${rawPath}/M_1154_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1159 ${rawPath}/M_1159_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1162 ${rawPath}/M_1162_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1168 ${rawPath}/M_1168_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1175 ${rawPath}/M_1175_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1176 ${rawPath}/M_1176_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1178 ${rawPath}/M_1178_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1180 ${rawPath}/M_1180_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1182 ${rawPath}/M_1182_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1191 ${rawPath}/M_1191_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1200 ${rawPath}/M_1200_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1203 ${rawPath}/M_1203_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1208 ${rawPath}/M_1208_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1215 ${rawPath}/M_1215_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1219 ${rawPath}/M_1219_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1232 ${rawPath}/M_1232_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                M_1254 ${rawPath}/M_1254_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_001 ${rawPath}/PTO_001_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_002 ${rawPath}/PTO_002_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_003 ${rawPath}/PTO_003_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_004 ${rawPath}/PTO_004_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_005 ${rawPath}/PTO_005_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_006 ${rawPath}/PTO_006_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_007 ${rawPath}/PTO_007_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_008 ${rawPath}/PTO_008_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_009 ${rawPath}/PTO_009_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_012 ${rawPath}/PTO_012_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_013 ${rawPath}/PTO_013_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_015 ${rawPath}/PTO_015_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_016 ${rawPath}/PTO_016_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_017 ${rawPath}/PTO_017_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_018 ${rawPath}/PTO_018_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_019 ${rawPath}/PTO_019_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_020 ${rawPath}/PTO_020_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_021 ${rawPath}/PTO_021_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_024 ${rawPath}/PTO_024_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_027 ${rawPath}/PTO_027_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_028 ${rawPath}/PTO_028_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_029 ${rawPath}/PTO_029_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_030 ${rawPath}/PTO_030_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_031 ${rawPath}/PTO_031_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_032 ${rawPath}/PTO_032_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_034 ${rawPath}/PTO_034_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_035 ${rawPath}/PTO_035_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_036 ${rawPath}/PTO_036_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_038 ${rawPath}/PTO_038_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                PTO_039 ${rawPath}/PTO_039_gradSHAP_${dvLabel}_1_thresh.nii.gz \
                -mask ${gmMask} \
                -covariates ${covFile} -center DIFF -exblur $blur \
                -Clustsim 25 -tempdir ${rawPath}/clustSim_${blur}mm \
                -prefix_clustsim ttest_SHAP_1_${dvLabel}_groupDiff_${blur}mm_${cov}_clustSim \
                -prefix ttest_SHAP_1_${dvLabel}_groupDiff_${blur}mm_${cov}
        endif
    endif
end

if ($THRESH_MAPS == 1) then
    # Group difference maps
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_group_abs.nii.gz
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_group_thresh95_mask.nii.gz
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_group_thresh95.nii.gz
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_group_thresh95_sub.nii.gz
    3dcalc -a ${rawPath}/ttest_SHAP_1_${dvLabel}_group.nii.gz -expr 'sqrt(a^2)' \
        -prefix ${rawPath}/ttest_SHAP_1_${dvLabel}_group_abs.nii.gz
    set groupAbs_95 = `3dBrickStat -percentile 95 1 95 ${rawPath}/ttest_SHAP_1_${dvLabel}_group_abs.nii.gz'[0]'`
    set currStat = $groupAbs_95[2]
    3dcalc -a ${rawPath}/ttest_SHAP_1_${dvLabel}_group_abs.nii.gz -expr "a-$currStat" \
        -prefix ${rawPath}/ttest_SHAP_1_${dvLabel}_group_thresh95_sub.nii.gz
    3dcalc -a ${rawPath}/ttest_SHAP_1_${dvLabel}_group_thresh95_sub.nii.gz -expr 'ispositive(a)' \
        -prefix ${rawPath}/ttest_SHAP_1_${dvLabel}_group_thresh95_mask.nii.gz
    3dcalc -a ${rawPath}/ttest_SHAP_1_${dvLabel}_group.nii.gz \
        -b ${rawPath}/ttest_SHAP_1_${dvLabel}_group_thresh95_mask.nii.gz \
        -expr 'a*b' -prefix ${rawPath}/ttest_SHAP_1_${dvLabel}_group_thresh95.nii.gz
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_group_thresh95_mask.nii.gz
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_group_thresh95_sub.nii.gz

    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_group_thresh99_mask.nii.gz
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_group_thresh99.nii.gz
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_group_thresh99_sub.nii.gz
    set groupAbs_99 = `3dBrickStat -percentile 99 1 99 ${rawPath}/ttest_SHAP_1_${dvLabel}_group_abs.nii.gz'[0]'`
    set currStat = $groupAbs_99[2]
    3dcalc -a ${rawPath}/ttest_SHAP_1_${dvLabel}_group_abs.nii.gz -expr "a-$currStat" \
        -prefix ${rawPath}/ttest_SHAP_1_${dvLabel}_group_thresh99_sub.nii.gz
    3dcalc -a ${rawPath}/ttest_SHAP_1_${dvLabel}_group_thresh99_sub.nii.gz -expr 'ispositive(a)' \
        -prefix ${rawPath}/ttest_SHAP_1_${dvLabel}_group_thresh99_mask.nii.gz
    3dcalc -a ${rawPath}/ttest_SHAP_1_${dvLabel}_group.nii.gz \
        -b ${rawPath}/ttest_SHAP_1_${dvLabel}_group_thresh99_mask.nii.gz \
        -expr 'a*b' -prefix ${rawPath}/ttest_SHAP_1_${dvLabel}_group_thresh99.nii.gz
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_group_abs.nii.gz
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_group_thresh99_mask.nii.gz
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_group_thresh99_sub.nii.gz

    # All subjs maps
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_abs.nii.gz
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_thresh95_mask.nii.gz
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_thresh95.nii.gz
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_thresh95_sub.nii.gz
    3dcalc -a ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs.nii.gz -expr 'sqrt(a^2)' \
        -prefix ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_abs.nii.gz
    set groupAbs_95 = `3dBrickStat -percentile 95 1 95 ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_abs.nii.gz'[0]'`
    set currStat = $groupAbs_95[2]
    3dcalc -a ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_abs.nii.gz -expr "a-$currStat" \
        -prefix ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_thresh95_sub.nii.gz
    3dcalc -a ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_thresh95_sub.nii.gz -expr 'ispositive(a)' \
        -prefix ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_thresh95_mask.nii.gz
    3dcalc -a ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs.nii.gz \
        -b ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_thresh95_mask.nii.gz \
        -expr 'a*b' -prefix ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_thresh95.nii.gz
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_thresh95_mask.nii.gz
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_thresh95_sub.nii.gz

    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_thresh99_mask.nii.gz
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_thresh99.nii.gz
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_thresh99_sub.nii.gz
    set groupAbs_99 = `3dBrickStat -percentile 99 1 99 ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_abs.nii.gz'[0]'`
    set currStat = $groupAbs_99[2]
    3dcalc -a ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_abs.nii.gz -expr "a-$currStat" \
        -prefix ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_thresh99_sub.nii.gz
    3dcalc -a ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_thresh99_sub.nii.gz -expr 'ispositive(a)' \
        -prefix ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_thresh99_mask.nii.gz
    3dcalc -a ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs.nii.gz \
        -b ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_thresh99_mask.nii.gz \
        -expr 'a*b' -prefix ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_thresh99.nii.gz
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_abs.nii.gz
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_thresh99_mask.nii.gz
    rm -f ${rawPath}/ttest_SHAP_1_${dvLabel}_allSubjs_thresh99_sub.nii.gz
endif