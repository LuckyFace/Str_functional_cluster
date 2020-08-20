Data for Shin et al., Spatial organization of functional clusters representing reward and movement information in the striatal direct and indirect pathways

Code information

regressCC: code for regression analysis of variables in classical conditioning task
behavior_regression: code for regression analysis of variables in open field test

behavior_extraction_video and behavior_extraction_video_5th_session: clustering of behaviors during open field test
behavior_collector: process of extraced behavior and calcium traces

correlation_decay: code for pair-wise correlation of neurons
spatio_correlation: spatial clustering algorithm using coefficient and spatial map (center.mat in data)
autocorrelation: gaussian filtered spaital map and autocorrelation

Data structure

clustsize: calculated cluster size with pairwise correlation (result from correlation_decay.m) and functional cluster (spatio_correlation) of 13 mice
behav_regression_session2_5: results from regression analysis of 4 behavior (forward, stop, contralatera turn and ipsilateral turn)
Tot_Spcor_coef_behav: Spatial clustering of neurons from 13 mice (result of the code: spatio_correlation.m) in open field test
center.mat: spatial map of neuron center in 13 mice
Behavior_trace: Raw calcium trace of 13 mice performing open field test
Tot_lick: Lick information in 13 mice performing classical conditioning task
Tot_fon: fraction of neurons significantly coding for variables in classical conditioing task in 13 mice
frameind_2.mat: sync information between video frame and calcium image frame

Following 3 files are zipped to Data.zip
1.Tot_behav_2_5: calcium traces of every neurons from 13 mice (3 WT, 5 D1R-cre and 5 A2a-cre mice) aligned to onset of behavior (Forward, Backwrad, stop and others)
2.Tot_Spcor_coef_13: Spatial clustering of neurons from 13 mice (result of the code: spatio_correlation.m) in classical conditioning task
3.Tot_corr: pair-wise correlation of neurons from 13 mice

rbcmap: colormap used for gaussian filtered spatial map (used in autocorrelation.m)

*Please contact Junghwan Shin (neosjh2009@gmail.com) for any questions.
