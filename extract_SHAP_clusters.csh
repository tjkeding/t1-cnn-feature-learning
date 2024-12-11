#!/bin/tcsh

# EXTRACT SHAP CLUSTERS - T1 Resiliency & Susceptibility Feature Learning
# Taylor Keding (tjkeding@gmail.com)

# Define directory
set shapDir = "/Volumes/Vol6/YouthPTSD/data/t1resiliency/allsubj/mri/CNN_featureLearning_proc"
set scripts = "/Volumes/Vol6/YouthPTSD/scripts/tjk_scripts/python_ML/CNN-feature-learning"
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

echo "SUBJ,ANALYSIS,ROI,SHAP,GMV" >> ${shapDir}/out/extraction_all_SHAP.csv
foreach subj ($subjs)

    set roi1_shap = `3dROIstats -quiet -nobriklab -mask ${shapDir}/out/ABUSE/SHAP/ABUSE_peak_top10_mask+tlrc'<1>' ${shapDir}/out/ABUSE/SHAP/${subj}_gradSHAP_ABUSE_1.nii.gz`
    set roi1_gmv = `3dROIstats -quiet -nobriklab -mask ${shapDir}/out/ABUSE/SHAP/ABUSE_peak_top10_mask+tlrc'<1>' ${shapDir}/${subj}_anat_CAT_GMV_noSmooth_scaledTIV_residScanner_std_gm.nii.gz`
    echo "${subj},ABUSE,Thalamus_Hippo,$roi1_shap,$roi1_gmv" >> ${shapDir}/out/extraction_all_SHAP.csv

    set roi2_shap = `3dROIstats -quiet -nobriklab -mask ${shapDir}/out/ABUSE/SHAP/ABUSE_peak_top10_mask+tlrc'<4>' ${shapDir}/out/ABUSE/SHAP/${subj}_gradSHAP_ABUSE_1.nii.gz`
    set roi2_gmv = `3dROIstats -quiet -nobriklab -mask ${shapDir}/out/ABUSE/SHAP/ABUSE_peak_top10_mask+tlrc'<4>' ${shapDir}/${subj}_anat_CAT_GMV_noSmooth_scaledTIV_residScanner_std_gm.nii.gz`
    echo "${subj},ABUSE,Pallidum_Caudate,$roi2_shap,$roi2_gmv" >> ${shapDir}/out/extraction_all_SHAP.csv

    set roi3_shap = `3dROIstats -quiet -nobriklab -mask ${shapDir}/out/ABUSE/SHAP/ABUSE_peak_top10_mask+tlrc'<7>' ${shapDir}/out/ABUSE/SHAP/${subj}_gradSHAP_ABUSE_1.nii.gz`
    set roi3_gmv = `3dROIstats -quiet -nobriklab -mask ${shapDir}/out/ABUSE/SHAP/ABUSE_peak_top10_mask+tlrc'<7>' ${shapDir}/${subj}_anat_CAT_GMV_noSmooth_scaledTIV_residScanner_std_gm.nii.gz`
    echo "${subj},ABUSE,ACC,$roi3_shap,$roi3_gmv" >> ${shapDir}/out/extraction_all_SHAP.csv

    set roi4_shap = `3dROIstats -quiet -nobriklab -mask ${shapDir}/out/ABUSE/SHAP/ABUSE_peak_top10_mask+tlrc'<8>' ${shapDir}/out/ABUSE/SHAP/${subj}_gradSHAP_ABUSE_1.nii.gz`
    set roi4_gmv = `3dROIstats -quiet -nobriklab -mask ${shapDir}/out/ABUSE/SHAP/ABUSE_peak_top10_mask+tlrc'<8>' ${shapDir}/${subj}_anat_CAT_GMV_noSmooth_scaledTIV_residScanner_std_gm.nii.gz`
    echo "${subj},ABUSE,Caudate,$roi4_shap,$roi4_gmv" >> ${shapDir}/out/extraction_all_SHAP.csv

    set roi5_shap = `3dROIstats -quiet -nobriklab -mask ${shapDir}/out/ABUSE/SHAP/ABUSE_peak_top10_mask+tlrc'<11>' ${shapDir}/out/ABUSE/SHAP/${subj}_gradSHAP_ABUSE_1.nii.gz`
    set roi5_gmv = `3dROIstats -quiet -nobriklab -mask ${shapDir}/out/ABUSE/SHAP/ABUSE_peak_top10_mask+tlrc'<11>' ${shapDir}/${subj}_anat_CAT_GMV_noSmooth_scaledTIV_residScanner_std_gm.nii.gz`
    echo "${subj},ABUSE,A_MCC,$roi5_shap,$roi5_gmv" >> ${shapDir}/out/extraction_all_SHAP.csv

    set roi6_shap = `3dROIstats -quiet -nobriklab -mask ${shapDir}/out/PSYCH/SHAP/PSYCH_peak_top10_mask+tlrc'<8>' ${shapDir}/out/PSYCH/SHAP/${subj}_gradSHAP_PSYCH_1.nii.gz`
    set roi6_gmv = `3dROIstats -quiet -nobriklab -mask ${shapDir}/out/PSYCH/SHAP/PSYCH_peak_top10_mask+tlrc'<8>' ${shapDir}/${subj}_anat_CAT_GMV_noSmooth_scaledTIV_residScanner_std_gm.nii.gz`
    echo "${subj},PSYCH,Parahippo,$roi6_shap,$roi6_gmv" >> ${shapDir}/out/extraction_all_SHAP.csv

    set roi7_shap = `3dROIstats -quiet -nobriklab -mask ${shapDir}/out/PSYCH/SHAP/PSYCH_peak_top10_mask+tlrc'<10>' ${shapDir}/out/PSYCH/SHAP/${subj}_gradSHAP_PSYCH_1.nii.gz`
    set roi7_gmv = `3dROIstats -quiet -nobriklab -mask ${shapDir}/out/PSYCH/SHAP/PSYCH_peak_top10_mask+tlrc'<10>' ${shapDir}/${subj}_anat_CAT_GMV_noSmooth_scaledTIV_residScanner_std_gm.nii.gz`
    echo "${subj},PSYCH,vlPFC,$roi7_shap,$roi7_gmv" >> ${shapDir}/out/extraction_all_SHAP.csv

end
