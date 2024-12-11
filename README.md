# t1-cnn-feature-learning

Preprocessing, Model Optimization, and Feature Importance Analyses for:

Differential Gray Matter Correlates and Machine Learning Prediction of Abuse and Internalizing Psychopathology in Adolescent Females
 
Background: Childhood abuse represents one of the most potent risk factors for the development of psychopathology during childhood, accounting for 30-60% of the risk for onset. While previous studies have separately associated reductions
in gray matter volume (GMV) with childhood abuse and internalizing psychopathology (IP), it is unclear whether abuse and IP differ in their structural abnormalities, and which GMV features are related to abuse and IP at the individual
level.

Methods: In a pooled multisite, multi-investigator sample, 246 child and adolescent females between the ages of 8-18 were recruited into studies of interpersonal violence (IPV) and/or IP (i.e. posttraumatic stress disorder
(PTSD),depression, and/or anxiety).  Youth completed assessments for IP, childhood abuse history, and underwent high resolution T1 structural MRI. First, we characterized how differences in GMV associated with childhood abuse exposure
depend on the presence or absence of IP using voxel-based morphometry (VBM). Next, we trained convolutional neural networks to predict individual psychopathology and abuse experience and estimated the strength and direction of importance
of each structural feature in making individual-level predictions using Shapley values. Shapley values were aggregated across the entire cohort, and the top 1% of feature clusters with the highest importance are reported.

Results: At a group-level, VBM analyses identified widespread decreases in GMV across the prefrontal cortex, insula, and hippocampus in youth with IP, while abuse experience was specifically associated with increased GMV in the cingulate
cortex and supramarginal gyrus. Further, interactions between IP and severity of abuse were identified in the ventral and dorsal prefrontal cortex, anterior cingulate cortex, and thalamus. After extensive training, model tuning, and model
evaluation, the neural networks performed above chance when predicting IP (63% accuracy) and abuse experiences (71% accuracy) at the level of the individual. Interestingly, structural regions with the highest importance in making
individual IP predictions had a high degree of overlap with group-level patterns.

Conclusions: We have identified unique structural correlates of childhood abuse and IP on both the group and individual level with a high degree of overlap, providing evidence that IP and trauma exposure may uniquely and jointly impact
child and adolescent structural neurodevelopment. Feature learning may offer power and novelty above and beyond traditional group-level approaches to the identification of biomarkers and a movement towards individualized diagnosis and
treatment.
