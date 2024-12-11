#!/bin/tcsh

# EXTRACT ALL SHAP VALUES - T1 Resiliency & Susceptibility Feature Learning
# Taylor Keding (tjkeding@gmail.com)

# Define directory
set shapDir = "/Volumes/Vol6/YouthPTSD/data/t1resiliency/allsubj/mri/CNN_featureLearning_proc"
set scripts = "/Volumes/Vol6/YouthPTSD/scripts/tjk_scripts/python_ML/CNN-feature-learning"
set gmMask =  "/Volumes/Vol6/YouthPTSD/data/t1resiliency/allsubj/mri/CNN_featureLearning_proc/MNI152_T1_1.5mm_gm_resamp_const1.nii.gz"
set subjs = ("ACE_001" "ACE_004" "ACE_005" "ACE_006" "ACE_007" "ACE_008" "ACE_009" "ACE_010" "ACE_011" \
    "ACE_012" "ACE_014" "ACE_015" "ACE_016" "ACE_017" "ACE_018" "ACE_019" "ACE_022" "ACE_023" "ACE_024" \
    "ACE_026" "ACE_027" "ACE_028" "ACE_029" "ACE_031" "ACE_032" "ACE_034" "ACE_035" "aPAL_001" "aPAL_002" \
    "aPAL_005" "aPAL_008" "aPAL_010" "aPAL_011" "aPAL_012" "aPAL_015" "aPAL_016" "aPAL_017" "aPAL_018" \
    "aPAL_020" "aPAL_021" "aPAL_023" "aPAL_024" "aPAL_025" "aPAL_026" "aPAL_027" "aPAL_028" "aPAL_030" \
    "aPAL_036" "aPAL_037" "aPAL_043" "aPAL_045" "aPAL_047" "aPAL_050" "aPAL_053" "aPAL_054" "aPAL_055" \
    "aPAL_056" "aPAL_058" "aPAL_059" "aPAL_063" "aPAL_064" "aPAL_066" "H_013" "H_043" "H_057" "H_058" \
    "H_059" "H_060" "H_061" "H_071" "H_085" "H_087" "H_089" "H_092" "H_093" "H_094" "H_097" "H_099" \
    "H_100" "H_112" "H_117" "H_125" "H_128" "H_134" "H_142" "H_145" "H_148" "H_149" "H_156" "M_1004" \
    "M_1005" "M_1006" "M_1007" "M_1008" "M_1011" "M_1015" "M_1019" "M_1030" "M_1032" "M_1043" "M_1045" \
    "M_1047" "M_1048" "M_1049" "M_1050" "M_1056" "M_1063" "M_1077" "M_1091" "M_1092" "M_1098" "M_1105" \
    "M_1106" "M_1115" "M_1128" "M_1133" "M_1152" "M_1153" "M_1173" "M_1175" "M_1176" "M_1191" "M_1197" \
    "M_1198" "M_1199" "M_1200" "M_1208" "M_1215" "M_1218" "M_1219" "M_1223" "M_1226" "M_1232" "M_1237" \
    "M_1240" "M_1245" "M_1246" "M_1248" "M_1250" "M_1262" "MAD_002" "MAD_003" "MAD_005" "MAD_006" "MAD_010" \
    "MAD_011" "MAD_015" "MAD_016" "MAD_018" "ACE_013" "ACE_021" "ACE_025" "ACE_033" "ACE_037" "aPAL_004" \
    "aPAL_009" "aPAL_014" "aPAL_019" "aPAL_022" "aPAL_034" "aPAL_035" "aPAL_038" "aPAL_039" "aPAL_040" \
    "aPAL_041" "aPAL_044" "aPAL_046" "aPAL_048" "aPAL_052" "aPAL_067" "H_026" "H_029" "H_031" "H_045" \
    "H_073" "H_075" "H_078" "H_079" "H_082" "H_086" "H_104" "H_122" "H_124" "H_127" "H_132" "H_133" \
    "H_138" "H_139" "H_154" "M_1009" "M_1014" "M_1037" "M_1038" "M_1090" "M_1113" "M_1117" "M_1124" \
    "M_1125" "M_1139" "M_1142" "M_1148" "M_1150" "M_1154" "M_1158" "M_1159" "M_1162" "M_1168" "M_1178" \
    "M_1180" "M_1182" "M_1184" "M_1195" "M_1203" "M_1254" "PTO_001" "PTO_002" "PTO_003" "PTO_004" \
    "PTO_005" "PTO_006" "PTO_007" "PTO_008" "PTO_009" "PTO_010" "PTO_012" "PTO_013" "PTO_015" "PTO_016" \
    "PTO_017" "PTO_018" "PTO_019" "PTO_020" "PTO_021" "PTO_024" "PTO_027" "PTO_028" "PTO_029" "PTO_030" \
    "PTO_031" "PTO_032" "PTO_034" "PTO_035" "PTO_036" "PTO_038" "PTO_039")


foreach dvLabel ("ABUSE" "PSYCH")
    # if ( ${dvLabel} == "ABUSE") then
    #     set outlierThresh = "0.0004117661"
    # else
    #     set outlierThresh = "0.0002452996"
    # endif

    
    # foreach subj ($subjs)
    #     # REMOVE OUTLIERS
    #     3dcalc -a ${shapDir}/out/${dvLabel}/SHAP/${subj}_gradSHAP_${dvLabel}_1.nii.gz -expr 'ispositive(0.0004117661-abs(a))' \
    #         -prefix ${shapDir}/out/${dvLabel}/SHAP/${subj}_gradSHAP_${dvLabel}_1_mask.nii.gz
    #     3dcalc -a ${shapDir}/out/${dvLabel}/SHAP/${subj}_gradSHAP_${dvLabel}_1.nii.gz \
    #         -b ${shapDir}/out/${dvLabel}/SHAP/${subj}_gradSHAP_${dvLabel}_1_mask.nii.gz \
    #         -expr 'a*b' -prefix ${shapDir}/out/${dvLabel}/SHAP/${subj}_gradSHAP_${dvLabel}_1_noOut.nii.gz
    #     rm -f ${shapDir}/out/${dvLabel}/SHAP/${subj}_gradSHAP_${dvLabel}_1_mask.nii.gz

    #     # APPLY SMOOTHING
    #     3dBlurInMask -mask ${gmMask} -FWHM 6 -input ${shapDir}/out/${dvLabel}/SHAP/${subj}_gradSHAP_${dvLabel}_1_noOut.nii.gz \
    #         -prefix ${shapDir}/out/${dvLabel}/SHAP/${subj}_gradSHAP_${dvLabel}_1_noOut_blur6.nii.gz

    #     # CALCULATE THE ABSOLUTE VAUE
    #     3dcalc -a ${shapDir}/out/${dvLabel}/SHAP/${subj}_gradSHAP_${dvLabel}_1_noOut_blur6.nii.gz -expr 'abs(a)' \
    #         -prefix ${shapDir}/out/${dvLabel}/SHAP/${subj}_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz
    # end

    # CREATE MEAN MAPS
    set rawPath = ${shapDir}/out/${dvLabel}/SHAP
    # 3dMean -prefix ${rawPath}/mean_SHAP_1_${dvLabel}_allSubjs.nii.gz \
    #     ${rawPath}/ACE_001_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_004_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_005_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_006_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_007_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_008_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_009_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_010_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_011_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_012_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_014_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_015_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_016_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_017_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_018_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_019_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_022_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_023_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_024_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_026_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_027_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_028_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_029_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_031_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_032_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_034_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_035_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_001_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_002_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_005_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_008_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_010_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_011_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_012_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_015_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_016_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_017_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_018_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_020_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_021_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_023_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_024_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_025_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_026_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_027_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_028_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_030_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_036_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_037_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_043_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_045_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_047_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_050_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_053_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_054_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_055_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_056_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_058_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_059_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_063_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_064_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_066_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_013_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_043_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_057_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_058_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_059_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_060_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_061_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_071_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_085_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_087_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_089_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_092_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_093_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_094_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_097_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_099_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_100_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_112_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_117_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_125_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_128_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_134_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_142_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_145_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_148_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_149_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_156_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1004_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1005_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1006_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1007_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1008_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1011_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1015_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1019_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1030_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1032_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1043_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1045_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1047_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1048_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1049_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1050_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1056_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1063_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1077_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1091_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1092_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1098_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1105_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1106_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1115_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1128_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1133_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1152_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1153_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1173_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1175_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1176_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1191_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1197_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1198_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1199_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1200_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1208_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1215_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1218_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1219_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1223_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1226_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1232_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1237_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1240_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1245_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1246_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1248_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1250_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1262_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/MAD_002_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/MAD_003_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/MAD_005_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/MAD_006_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/MAD_010_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/MAD_011_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/MAD_015_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/MAD_016_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/MAD_018_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_013_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_021_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_025_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_033_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/ACE_037_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_004_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_009_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_014_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_019_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_022_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_034_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_035_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_038_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_039_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_040_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_041_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_044_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_046_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_048_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_052_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/aPAL_067_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_026_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_029_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_031_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_045_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_073_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_075_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_078_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_079_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_082_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_086_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_104_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_122_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_124_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_127_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_132_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_133_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_138_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_139_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/H_154_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1009_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1014_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1037_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1038_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1090_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1113_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1117_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1124_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1125_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1139_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1142_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1148_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1150_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1154_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1158_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1159_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1162_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1168_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1178_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1180_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1182_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1184_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1195_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1203_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/M_1254_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_001_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_002_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_003_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_004_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_005_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_006_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_007_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_008_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_009_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_010_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_012_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_013_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_015_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_016_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_017_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_018_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_019_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_020_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_021_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_024_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_027_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_028_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_029_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_030_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_031_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_032_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_034_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_035_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_036_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_038_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz \
    #     ${rawPath}/PTO_039_gradSHAP_${dvLabel}_1_noOut_blur6_abs.nii.gz

    # # THRESHOLD MEAN MAPS
    # foreach currThresh ("99" "99.9")
    #     if ( ${currThresh} == "99") then
    #         set percOut = "0.01"
    #     else
    #         set percOut = "0.001"
    #     endif
    #     set stat_out = `3dBrickStat -mask ${gmMask} -percentile ${currThresh} 1 ${currThresh} -non-zero ${rawPath}/mean_SHAP_1_${dvLabel}_allSubjs.nii.gz`
    #     set thresh = "$stat_out[2]"
    #     3dcalc -a ${rawPath}/mean_SHAP_1_${dvLabel}_allSubjs.nii.gz -expr "ispositive(a-${thresh})" \
    #         -prefix ${rawPath}/mean_SHAP_1_${dvLabel}_allSubjs_mask.nii.gz
    #     3dcalc -a ${rawPath}/mean_SHAP_1_${dvLabel}_allSubjs.nii.gz -b ${rawPath}/mean_SHAP_1_${dvLabel}_allSubjs_mask.nii.gz \
    #         -c ${gmMask} -expr 'a*b*c' -prefix ${rawPath}/mean_SHAP_1_${dvLabel}_allSubjs_${percOut}thresh.nii.gz
    #     rm -f ${rawPath}/mean_SHAP_1_${dvLabel}_allSubjs_mask.nii.gz
    # end

    ## EXTRACT SHAP AND GMV CLUSTERS
    # set rawPath = ${shapDir}/out/${dvLabel}/SHAP
    foreach subj ($subjs)
        echo -n "${subj}," >> ${rawPath}/${dvLabel}_SHAP_0.01_top10_extraction.csv
        foreach roi ("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
            set shap = `3dmaskave -quiet -mask ${rawPath}/${dvLabel}_SHAP_0.01_top10_mask+tlrc"<${roi}>" ${rawPath}/${subj}_gradSHAP_${dvLabel}_1_noOut_blur6.nii.gz`
            set gmv = `3dmaskave -quiet -mask ${rawPath}/${dvLabel}_SHAP_0.01_top10_mask+tlrc"<${roi}>" ${shapDir}/${subj}_anat_CAT_GMV_noSmooth_scaledTIV_residScanner_std_gm.nii.gz`
            if ( $roi == "10") then
                echo "${shap},${gmv}" >> ${rawPath}/${dvLabel}_SHAP_0.01_top10_extraction.csv
            else
                echo -n "${shap},${gmv}," >> ${rawPath}/${dvLabel}_SHAP_0.01_top10_extraction.csv
            endif
        end
    end
end