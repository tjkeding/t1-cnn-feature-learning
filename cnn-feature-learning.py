#!/usr/bin/python3
# coding: utf-8

# =======================================================================================================================
# FEATURE LEARNING using a CONVOLUTIONAL NEURAL NETWORK and SHAP FEATURE IMPORTANCE
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
# Prevent TensorFlow/Keras output messages
# Change to '3' after development (removes everything, including errors)
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3' 
import csv
import copy
import itertools
from datetime import datetime
from time import sleep
import multiprocessing as mp
import subprocess

# NiBabel
import nibabel as nib

# Joblib:
import joblib as joblib
from joblib import Parallel, delayed

# Scikit-Learn:
import sklearn
from sklearn.metrics import accuracy_score,balanced_accuracy_score,roc_auc_score,f1_score,\
    precision_score,recall_score,average_precision_score
from sklearn.model_selection import StratifiedKFold
from sklearn.utils import compute_class_weight

# Numpy:
import numpy as np

# Pandas:
import pandas as pd

# Tensorflow
import tensorflow as tf
#tf.compat.v1.disable_eager_execution()
#tf.compat.v1.disable_v2_behavior()
tf.config.set_soft_device_placement(True)
from tensorflow.python.client import device_lib
from tensorflow.keras.metrics import Recall

# Keras:
import keras
import tensorflow.compat.v1.keras.backend as K_v1
import tensorflow.keras.backend as K
#tf.keras.backend.set_floatx('float64')
from tensorflow.keras.models import Sequential,Model,load_model,save_model,clone_model
from tensorflow.keras.layers import Input,Dense,Flatten,Conv3D,MaxPooling3D,AveragePooling3D,GlobalMaxPooling3D,\
    Dropout,BatchNormalization,Concatenate
from tensorflow.keras.activations import elu
from tensorflow.keras.optimizers import Adam, SGD
from tensorflow.keras.callbacks import EarlyStopping,ModelCheckpoint,ReduceLROnPlateau
from keras.utils import np_utils

# SciPy:
import scipy
from scipy import ndimage
import scipy.stats as stats
from scipy.stats import loguniform,uniform,pearsonr,wilcoxon

# HpBandster:
# import hpbandster.core.nameserver as hpns
# import hpbandster.core.result as hpres
# from hpbandster.optimizers import BOHB
# from KerasWorker import KerasWorker as worker

# Optuna:
import optuna
from optuna.samplers import NSGAIISampler

# SHAP:
import shap

# DeepExplain
#from deepexplain.tensorflow import DeepExplain

# Start the timer
startTime = datetime.now()

# -----------------------------------------------------------------------------------------------------------------------
# FUNCTIONS:
# -----------------------------------------------------------------------------------------------------------------------

def check_args_read_data(args):
    
    print("")
    print("   CHECK ARGUMENTS, READ-IN DATA")
    print("   ---------------------------------------------------------")

    # Check for the correct number of args
    if(len(sys.argv)!= 10):
        print("   Incorrect number of args! 9 Required:")
        printUsage()
        sys.exit()

    # Check args[1]: read-in CSV training set file
    try:
        DF = pd.read_csv(args[1])
        subjData = {'subj':list(DF[DF.columns[0]]),'label':list(DF[DF.columns[1]])}
    except:
        print("   Subject data file could not be found!")
        printUsage()
        sys.exit()

    # Check args[2]: get the map file directory (organized by subject [BIDS])
    mapFileDir = str(args[2])

    # Check args[3]: get prefix for output files
    prefix = str(args[3])

    # Check args[4]: get a dependent variable label
    dvLabel = str(args[4])

    # Check args[5]: Check if kCV_MB is in correct format
    try:
        kCV_MB = int(args[5])
    except:
        print("   <kCV_MB> is incorrect (must be an int)")
        printUsage()
        sys.exit()

    # Check args[6]: Check if numSamp_MB is in correct format
    try:
        numSamp_MB = int(args[6])
        if numSamp_MB <= 1:
            print("   <numSamp_MB> must be greater than 1")
            printUsage()
            sys.exit()
    except:
        print("   <numSamp_MB> is incorrect (must be an int)")
        printUsage()
        sys.exit()

    # Check args[7]: Check if numSamp_evalFI is in correct format
    try:
        numSamp_evalFI = int(args[7])
        if numSamp_evalFI <= 1:
            print("   <numSamp_evalFI> must be greater than 1")
            printUsage()
            sys.exit()
    except:
        print("   <numSamp_evalFI> is incorrect (must be an int)")
        printUsage()
        sys.exit()

    # Check args[8]: check if the number of cores for model building is correct
    try:
        numCores_MB = int(args[8])
        if(numCores_MB > mp.cpu_count() or (numCores_MB < 1 and numCores_MB != -1)):
            print("   Specifed too many (or too few) cores for model building!")
            print("   If you want to use all available, input '-1")
            printUsage()
            sys.exit()
    except:
        print("   Number of cores for model building is not an integer!")
        printUsage()
        sys.exit()

    # Check args[9]: check if the number of cores for model evaluation and feature importance is correct
    try:
        numCores_evalFI = int(args[9])
        if(numCores_evalFI > mp.cpu_count() or (numCores_evalFI < 1 and numCores_evalFI != -1)):
            print("   Specifed too many (or too few) cores for model evalutation and feature importance!")
            print("   If you want to use all available, input '-1")
            printUsage()
            sys.exit()
    except:
        print("   Number of cores for model evaluation and feature importance is not an integer!")
        printUsage()
        sys.exit()

    return {'subjData':subjData,'mapFileDir':mapFileDir,'prefix':prefix,'dvLabel':dvLabel,'kCV_MB':kCV_MB, \
        'numSamp_MB':numSamp_MB,'numSamp_evalFI':numSamp_evalFI,'numCores_MB':numCores_MB,'numCores_evalFI':numCores_evalFI}

# --------------------

def printUsage():
    toPrint = str("   python3 cnn-feature-learning.py <dataFile> <mapFileDir> <prefix> <dvLabel> \n"+\
        "       <kCV_MB> <numSamp_MB> <numSamp_evalFI> <numCores_MB> <numCores_evalFI>")
    print(toPrint)

# --------------------

def readNIFTI(subjList,mapFileDir):

    # Read-in NIFTI brain data for each subject in the subject list
    try:
        outData = []
        for subj in subjList:

            # Get voxel map of brain data to be analyzed
            brain = nib.load(f"{mapFileDir}/{subj}_anat_CAT_GMV_noSmooth_scaledTIV_residScanner_std_gm.nii.gz")
            brain_data = brain.get_fdata()

            # Merge multiple images into a single multi-channel image
            mc_image = brain_data
            #mc_image = np.stack([fc_data,fa_data],axis=-1)

            # Adjust dimensions if there is only a single channel
            if len(mc_image.shape) < 4:
                mc_image = np.expand_dims(mc_image,3)

            # Append multi-channel image for this subject
            outData.append(mc_image)

    except:
        print("   NIFTI data could not be loaded. Please ensure <mapFileDir> \n"+\
            "   input is correct and subject directory/files are named correctly.")
        printUsage()
        sys.exit()

    return removeSurroundingZeros(outData)

# --------------------

def removeSurroundingZeros(brainData):

    # Placeholders
    out_x_b = 1000
    out_x_e = 1000
    out_y_b = 1000
    out_y_e = 1000
    out_z_b = 1000
    out_z_e = 1000

    # Iterate through subject data
    for brain in brainData:

        # Make a copy for manipulating
        copyData = copy.deepcopy(brain)
        y = np.swapaxes(copyData,0,1)
        z = np.swapaxes(copyData,0,2)

        # Get number of slices to remove
        x_b = countEdgeZeros(copyData,"b")
        if x_b < out_x_b:
            out_x_b = x_b

        x_e = countEdgeZeros(copyData,"e")
        if x_e < out_x_e:
            out_x_e = x_e

        y_b = countEdgeZeros(y,"b")
        if y_b < out_y_b:
            out_y_b = y_b

        y_e = countEdgeZeros(y,"e")
        if y_e < out_y_e:
            out_y_e = y_e

        z_b = countEdgeZeros(z,"b")
        if z_b < out_z_b:
            out_z_b = z_b

        z_e = countEdgeZeros(z,"e")
        if z_e < out_z_e:
            out_z_e = z_e

    # Iterate through subject data again, trimming each set of data
    toReturn = []
    for brain in brainData:
        toReturn.append(brain[out_x_b:-out_x_e,out_y_b:-out_y_e,out_z_b:-out_z_e,:])

    return {'trimmed_data':np.array(toReturn),'padding':[out_x_b,out_x_e,out_y_b,out_y_e,out_z_b,out_z_e]}

# --------------------

def countEdgeZeros(currOrient,choice):

    toReturn = 0
    if choice == "e":
        toIterate = reversed(currOrient)
    else:
        toIterate = currOrient

    for i in toIterate:
        if np.sum(i) == 0.0:
            toReturn += 1
        else:
            break

    return toReturn

# --------------------

def getCVBatches(kCV_MB,subjData):
    
    outDict={}

    # Define the fold creation strategy
    ss = StratifiedKFold(n_splits=kCV_MB,shuffle=True,random_state=np.random.RandomState())

    # Keep track for batch names in the dictionary and create splits
    batch = 1
    for train_index, test_index in ss.split(subjData['data']['X'],subjData['data']['y']):

        # Split data based on indices
        id_train,id_test = np.array(subjData['subj'])[train_index],np.array(subjData['subj'])[test_index]
        X_train, X_test = np.array(subjData['data']['X'])[train_index],np.array(subjData['data']['X'])[test_index]
        y_train, y_test = np.array(subjData['data']['y'])[train_index],np.array(subjData['data']['y'])[test_index]

        outDict[str(batch)]={'X_train':X_train,'X_test':X_test,'y_train_cat':np_utils.to_categorical(y_train,2),\
            'y_test_cat':np_utils.to_categorical(y_test,2),'y_train_orig':y_train,'y_test_orig':y_test,\
            'id_train':id_train,'id_test':id_test}
        batch = batch + 1

    return outDict

# --------------------

def formatSetData(setData,setLabels):
    
    # Define which indices to format
    indices = list(range(setData.shape[0]))

    # Create X and y np arrays
    X_train = np.array(setData)[indices]
    y_train = np.array(setLabels)[indices]

    return {'X':X_train,'y':y_train}

# --------------------

def tuneFLModels(kCV_MB,cvBatches,dvLabel,prefix,toBuild,numSamp_MB,numCores_MB):

    print("")
    print("   BUILDING THE FEATURE LEARNING MODEL")
    print("   ---------------------------------------------------------")
    print("   Performing hyperparameter tuning and model training.")

    # DEFINE dataShape, batchSize, epochs, and early stopping HERE:
    # MODEL SPECIFIC PARAMETERS THAT NEED TO BE CHANGED FOR SPECIFIC SITUATIONS
    # CHANGE CHANNEL NUMBER WHEN FA DATA IS AVAILABLE
    batchSize = 35
    epochs = 500
    warm_start = 50
    earlyStop = 75
    minDelta = 0.025

    ################################################
    # USING OPTUNA:
    ################################################
    for currBatch in toBuild:

        # Tune a feature learning model's hyperparameters with the current batch
        if not os.path.exists(f"{prefix}/{dvLabel}/optuna/batch_{currBatch}/trials_out"):
            startTime = datetime.now()
            paramSearch_optuna(kCV_MB,prefix,dvLabel,currBatch,cvBatches[currBatch],\
                batchSize,earlyStop,minDelta,epochs,warm_start,numSamp_MB)
            print(f"   .....Done with batch {currBatch}!")
            print("   .....Total Time: "+str(datetime.now()-startTime))

        # Train a final model with the optimized hyperparameters
        if not os.path.exists(f"{prefix}/{dvLabel}/models/batch_{currBatch}/bestModel_final"):
            startTime = datetime.now()
            buildModelWithParams(batchSize,epochs,earlyStop,warm_start,minDelta,\
                currBatch,cvBatches[currBatch],dvLabel,prefix)
            print(f"   .....Final model trained for batch {currBatch}!")
            print("   .....Total Time: "+str(datetime.now()-startTime))

    # Parallel(n_jobs=numCores_MB)(delayed(paramSearch_optuna)(kCV_MB=kCV_MB,prefix=prefix,dvLabel=dvLabel,\
    #     batchID=currBatch,batch=cvBatches[currBatch],batchSize=batchSize,earlyStop=earlyStop,minDelta=minDelta,\
    #     epochs=epochs,warm_start=warm_start,nIter=numSamp_MB) for currBatch in toBuild)

    '''
    ################################################
    # USING BHOB:
    ################################################
    # for currBatch in toBuild:
    #     paramSearch_BHOB(kCV_MB=kCV_MB,hostName="mri-thor",prefix=prefix,dvLabel=dvLabel,\
    #         batchID=currBatch,batch=cvBatches[currBatch],batchSize=batchSize,\
    #         minBudget=minBudget,maxBudget=maxBudget,nIter=nIter)

    # Parallel(n_jobs=numCores_MB)(delayed(paramSearch)(kCV_MB=kCV_MB,hostName="mri-thor",\
    #     prefix=prefix,dvLabel=dvLabel,batchID=currBatch,batch=cvBatches[currBatch],batchSize=batchSize,\
    #     minBudget=minBudget,maxBudget=maxBudget,nIter=nIter) for currBatch in toBuild)

    ################################################
    # USING RANDOMIZED PARAMETER SEARCH:
    ################################################
    # Get params to use
    # params = getParams(False)

    # Iterate batches of cross validation
    # Parallel(n_jobs=numCores_MB)(delayed(buildModelWithParams)(params=params,batchSize=batchSize,\
    #     epochs=epochs,earlyStop=earlyStop,batchKey=currBatch,batch=cvBatches[currBatch],dvLabel=dvLabel,\
    #     prefix=prefix) for currBatch in toBuild)
    '''

    print('   .....Complete!')

# --------------------

def buildModelWithParams(batchSize,epochs,earlyStop,warm_start,minDelta,batchKey,batch,dvLabel,prefix):

    # Create a new directory for this batch
    if not os.path.exists(f"{prefix}/{dvLabel}/models/batch_{batchKey}"):
        subprocess.run(['mkdir',f"{prefix}/{dvLabel}/models/batch_{batchKey}"])

    # Get the best parameters for this batch
    bestTrials = joblib.load(f"{prefix}/{dvLabel}/optuna/batch_{batchKey}/trials_out")['best_trials']
    if len(bestTrials)>1:
        bestParams = None
        bestScore = np.sqrt(2)
        for trial in bestTrials:
            currDist = np.sqrt((1-trial.values[0])**2+(trial.values[1])**2)
            if currDist < bestScore:
                bestScore = currDist
                bestParams = trial.params
    else:
        bestParams = bestTrials[0].params
    
    # Build the model with best parameters
    currModel = buildCNN_optuna(None,batch['X_train'][0].shape,\
        len(set(batch['y_train_orig'])),bestParams)
    optModel = clone_model(currModel)

    # Choose the optimizer and compile model
    # "run_eagerly" added to compilation to ensure "balancedAccuracy" metric works
    if bestParams['optimizer'] == 'Adam':
        optChoice = Adam(lr=bestParams['lr'])
    else:
        optChoice = SGD(lr=bestParams['lr'])
    currModel.compile(loss="binary_crossentropy",optimizer=optChoice,\
        metrics=[balancedAccuracy],run_eagerly=True)
    
    # Define model callbacks for reducing the model learning rate, early stopping, and hyperband pruning
    redLR = ReduceLROnPlateau(monitor='val_balancedAccuracy',factor=0.8,patience=round(earlyStop/3.0),\
        mode='max',min_delta=minDelta,min_lr=1e-5)
    es = EarlyStopping(monitor='val_balancedAccuracy',mode='max',verbose=0,patience=earlyStop,\
        min_delta=minDelta,restore_best_weights=True)
    mc = ModelCheckpoint(filepath=f"{prefix}/{dvLabel}/models/batch_{batchKey}/bestWeights.ckpt",\
        monitor='val_balancedAccuracy',mode='max',save_best_only=True,save_weights_only=True)

    # Fit the model for 'warm_start' epochs before implementing early stopping
    currModel.fit(batch['X_train'],batch['y_train_cat'],batch_size=batchSize,epochs=warm_start,\
        verbose=0,validation_data=(batch['X_test'],batch['y_test_cat']),shuffle=True)
    
    # After 'warm_start' epochs, begin early stopping
    currModel.fit(batch['X_train'],batch['y_train_cat'],batch_size=batchSize,epochs=epochs,\
        verbose=0,validation_data=(batch['X_test'],batch['y_test_cat']),shuffle=True,callbacks=[redLR,es,mc])

    # Load the best model weights from early stopping and save the model
    optModel.compile(loss="binary_crossentropy",optimizer=optChoice,metrics=[balancedAccuracy],run_eagerly=True)
    optModel.load_weights(f"{prefix}/{dvLabel}/models/batch_{batchKey}/bestWeights.ckpt")
    save_model(optModel,f"{prefix}/{dvLabel}/models/batch_{batchKey}/bestModel_final")

# --------------------

def getParams(returnAll):

    outDict = {}
    # Return all possible hyperparameter options for search
    if returnAll:

        # Options for ADAM:
        outDict['lr'] = [0.0001,0.0005,0.001,0.005,0.01,0.05,0.1]

        # Options for the number of filters in each convolution block
        outDict['conv_filters_1'] = list(range(20,101))[::5]
        outDict['conv_filters_2'] = list(range(20,101))[::5]
        outDict['conv_filters_3'] = list(range(20,101))[::5]

        # Options for the dropout rates in each convolution block
        outDict['dropout_rate_1'] = [0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6,0.65,0.7,0.75]
        outDict['dropout_rate_2'] = [0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6,0.65,0.7,0.75]
        outDict['dropout_rate_3'] = [0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6,0.65,0.7,0.75]

        # Options for the fully-connected layers
        outDict['hidden_units_FC_1'] = list(range(201))[::10][1:]
        outDict['hidden_units_FC_2'] = list(range(201))[::10][1:]
        outDict['dropout_rate_FC_0'] = [0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6,0.65,0.7,0.75]
        outDict['dropout_rate_FC_1'] = [0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6,0.65,0.7,0.75]
        outDict['dropout_rate_FC_2'] = [0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.45,0.5,0.55,0.6,0.65,0.7,0.75]

    # Return specific parameters (used during testing and for a priori models)
    else:

        # Options for optimizers:
        outDict['lr'] = 0.01

        # Options for the number of filters in each convolution block
        outDict['conv_filters_1'] = 30
        outDict['conv_filters_2'] = 60
        outDict['conv_filters_3'] = 90
        outDict['conv_filters_4'] = 80

        # Options for the dropout rates in each convolution block
        outDict['dropout_rate_1'] = 0.5
        outDict['dropout_rate_2'] = 0.5
        outDict['dropout_rate_3'] = 0.5
        outDict['dropout_rate_4'] = 0.5

        # Options for the fully-connected layers
        outDict['hidden_units_FC_1'] = 100
        outDict['hidden_units_FC_2'] = 50
        outDict['dropout_rate_FC_0'] = 0.5
        outDict['dropout_rate_FC_1'] = 0.5
        outDict['dropout_rate_FC_2'] = 0.5

    return outDict

# --------------------

def getRandParams(params):

    out = {}
    rng = np.random.RandomState()
    for key in params:
        out[key] = params[key][rng.randint(len(params[key]))]
    return out

# --------------------

def paramSearch_BHOB(kCV_MB,hostName,prefix,dvLabel,batchID,batch,batchSize,minBudget,maxBudget,nIter):

    # Utilizes Bayesian Optimization with Hyperband scheduling for parameter search
    # Implemented with the following instructions:
    # https://automl.github.io/HpBandSter/build/html/auto_examples/example_5_mnist.html#

    # Get CV splits for hyperparameter tuning
    mbBatch={}

    # Define the fold creation strategy
    ss = StratifiedKFold(n_splits=kCV_MB,shuffle=True,random_state=np.random.RandomState())

    # Get the number of classes
    numClasses = len(set(batch['y_train_orig']))

    # Keep track for batch names in the dictionary and create splits
    mbBatchNum = 1
    for train_index, test_index in ss.split(batch['X_train'],batch['y_train_orig']):

        # Split data based on indices
        X_train, X_test = np.array(batch['X_train'])[train_index],np.array(batch['X_train'])[test_index]
        y_train, y_test = np.array(batch['y_train_orig'])[train_index],np.array(batch['y_train_orig'])[test_index]

        mbBatch[str(mbBatchNum)]={'X_train':X_train,'X_test':X_test,\
            'y_train':np_utils.to_categorical(y_train,numClasses),\
            'y_test':np_utils.to_categorical(y_test,numClasses),
            'y_train_orig':y_train,'y_test_orig':y_test}
        mbBatchNum = mbBatchNum + 1

    # Create a new directory for this batch
    if not os.path.exists(f"{prefix}/{dvLabel}/BOHB_{batchID}"):
        subprocess.run(['mkdir',f"{prefix}/{dvLabel}/BOHB_{batchID}"])

    # Set the hostname
    #host = hpns.nic_name_to_host(hostName)

    # TODO: Figure out if this code is necessary
    # sleep(5)   # short artificial delay to make sure the nameserver is already running
    # w = worker(data=mbBatch,numClasses=numClasses,batchSize=batchSize,\
    #     run_id=f"batch{batchID}", host=hostName, timeout=120)
    # w.load_nameserver_credentials(working_directory=f"{prefix}/{dvLabel}/BOHB_{batchID}")
    # w.run(background=False)
    # exit(0)

    # Log live results. The core.result submodule contains the functionality to
    # read the two generated files (results.json and configs.json) and create a Result object.
    result_logger = hpres.json_result_logger(directory=f"{prefix}/{dvLabel}/BOHB_{batchID}",overwrite=True)

    # Start a nameserver:
    NS = hpns.NameServer(run_id=f"batch{batchID}",host=hostName,\
        port=0,working_directory=f"{prefix}/{dvLabel}/BOHB_{batchID}")
    ns_host, ns_port = NS.start()

    # Start local worker
    w = worker(data=mbBatch,numClasses=numClasses,batchSize=batchSize,run_id=f"batch{batchID}",\
        host=hostName,nameserver=ns_host,nameserver_port=ns_port,timeout=120)
    w.run(background=True)

    # Run an optimizer
    bohb = BOHB(configspace = worker.get_configspace(),run_id=f"batch{batchID}",\
        host=hostName,nameserver=ns_host,nameserver_port=ns_port,result_logger=result_logger,\
        min_budget=minBudget,max_budget=maxBudget)
    res = bohb.run(n_iterations=nIter)

    # store results
    joblib.dump(res,f"{prefix}/{dvLabel}/BOBH_{batchID}/bohb_results")

    # shutdown
    bohb.shutdown(shutdown_workers=True)
    NS.shutdown()

# --------------------

def paramSearch_optuna(kCV_MB,prefix,dvLabel,batchID,batch,batchSize,earlyStop,minDelta,epochs,warm_start,nIter):

    # Utilizes Multi-objective, Genetic Search with Learning-Rate Reduction and Early Stopping
    # Implemented with the following example:
    # https://github.com/optuna/optuna-examples/blob/main/keras/keras_integration.py

    # Get CV splits for hyperparameter tuning
    mbBatch={}

    # Define the fold creation strategy
    # Half the number of CV splits to reduce total run time
    ss = StratifiedKFold(n_splits=round(kCV_MB/2.0),shuffle=True,random_state=np.random.RandomState())

    # Get the number of classes
    numClasses = len(set(batch['y_train_orig']))

    # Keep track for batch names in the dictionary and create splits
    mbBatchNum = 1
    for train_index, test_index in ss.split(batch['X_train'],batch['y_train_orig']):

        # Split data based on indices
        X_train, X_test = np.array(batch['X_train'])[train_index],np.array(batch['X_train'])[test_index]
        y_train, y_test = np.array(batch['y_train_orig'])[train_index],np.array(batch['y_train_orig'])[test_index]

        mbBatch[str(mbBatchNum)]={'X_train':X_train,'X_test':X_test,\
            'y_train':np_utils.to_categorical(y_train,numClasses),\
            'y_test':np_utils.to_categorical(y_test,numClasses),
            'y_train_orig':y_train,'y_test_orig':y_test}
        mbBatchNum = mbBatchNum + 1

    # Create a new directory for this batch
    if not os.path.exists(f"{prefix}/{dvLabel}/optuna/batch_{batchID}"):
        subprocess.run(['mkdir',f"{prefix}/{dvLabel}/optuna/batch_{batchID}"])

    # Create an Optuna study
    study = optuna.create_study(directions=["maximize","minimize"],\
        sampler=NSGAIISampler(population_size=30))
    
    # Use Bayesian optimization with Hyperband pruning to tune hyperparameters
    study.optimize(lambda trial: objective(trial,data=mbBatch,batchSize=batchSize,\
        epochs=epochs,warm_start=warm_start,minDelta=minDelta,earlyStop=earlyStop,numClasses=numClasses,\
        prefix=prefix,dvLabel=dvLabel,batchID=batchID),n_trials=nIter)

    # Get statistics and save them
    outStats = {'best_trials':study.best_trials}

    # Save the optimized hyperparameters for this CV batch
    joblib.dump(outStats,f"{prefix}/{dvLabel}/optuna/batch_{batchID}/trials_out")

# --------------------

def objective(trial,data,batchSize,epochs,warm_start,minDelta,earlyStop,numClasses,prefix,dvLabel,batchID):

    # Clear clutter from previous session graphs
    keras.backend.clear_session()

    # Generate our trial model.
    model = buildCNN_optuna(trial,data['1']['X_train'][0].shape,numClasses,None)

    # Compile model and run cross validation batches
    testOut = []
    trainOut = []
    if trial.params['optimizer'] == 'Adam':
        optChoice = Adam(lr=trial.params['lr'])
    else:
        optChoice = SGD(lr=trial.params['lr'])

    for batch in data:

        # Remove files from unfinished, previous batches of cross validation
        if os.path.exists(f"{prefix}/{dvLabel}/optuna/batch_{batchID}/{batch}_bestWeights.ckpt.index"):
            os.remove(f"{prefix}/{dvLabel}/optuna/batch_{batchID}/{batch}_bestWeights.ckpt.index")
        if os.path.exists(f"{prefix}/{dvLabel}/optuna/batch_{batchID}/{batch}_bestWeights.ckpt.data-00000-of-00001"):
            os.remove(f"{prefix}/{dvLabel}/optuna/batch_{batchID}/{batch}_bestWeights.ckpt.data-00000-of-00001")
        if os.path.exists(f"{prefix}/{dvLabel}/optuna/batch_{batchID}/{batch}_bestWeights.ckpt"):
            os.remove(f"{prefix}/{dvLabel}/optuna/batch_{batchID}/{batch}_bestWeights.ckpt")

        # Create a copy of the model and compile
        # "run_eagerly" added to compilation to ensure "balancedAccuracy" metric works
        currModel = keras.models.clone_model(model)
        currModel.build(data['1']['X_train'][0].shape)
        currModel.compile(loss="binary_crossentropy",optimizer=optChoice,\
            metrics=[balancedAccuracy],run_eagerly=True)
        currModel.set_weights(model.get_weights())

        # Compute class weights to ensure classifier isn't guessing majority class
        # USE ONLY if not using a class imbalance robust metric (like raw accuracy)
        # classWeight = compute_class_weight('balanced',np.unique(data[batch]['y_train_orig']),\
        #     data[batch]['y_train_orig']) 
        # classWeight = dict(enumerate(classWeight))

        # Define model callbacks for reducing the model learning rate, early stopping, and hyperband pruning
        redLR = ReduceLROnPlateau(monitor='val_balancedAccuracy',factor=0.8,patience=round(earlyStop/3.0),\
            mode='max',min_delta=minDelta,min_lr=1e-5)
        es = EarlyStopping(monitor='val_balancedAccuracy',mode='max',verbose=0,patience=earlyStop,\
            min_delta=minDelta,restore_best_weights=True)
        mc = ModelCheckpoint(filepath=f"{prefix}/{dvLabel}/optuna/batch_{batchID}/{batch}_bestWeights.ckpt",\
            monitor='val_balancedAccuracy',mode='max',save_best_only=True,save_weights_only=True)
            
        # Fit the model for 'warm_start' epochs before implementing early stopping
        currModel.fit(data[batch]['X_train'],data[batch]['y_train'],batch_size=batchSize,\
            epochs=warm_start,verbose=0,validation_data=(data[batch]['X_test'],\
            data[batch]['y_test']),shuffle=True)
        # class_weight=classWeight - only use if not using a class imbalance robust metric (like raw accuracy)
        
        # After 'warm_start' epochs, begin early stopping
        currModel.fit(data[batch]['X_train'],data[batch]['y_train'],batch_size=batchSize,\
            epochs=epochs,verbose=0,validation_data=(data[batch]['X_test'],\
            data[batch]['y_test']),shuffle=True,callbacks=[redLR,es,mc])

        # Load the best model from early stopping
        optModel = keras.models.clone_model(model)
        optModel.compile(loss="binary_crossentropy",optimizer=optChoice,metrics=[balancedAccuracy],run_eagerly=True)
        optModel.load_weights(f"{prefix}/{dvLabel}/optuna/batch_{batchID}/{batch}_bestWeights.ckpt")

        # Get scores
        testOut.append(balanced_accuracy_score(data[batch]['y_test_orig'],\
            np.argmax(optModel.predict(data[batch]['X_test']),axis=-1)))
        trainOut.append(balanced_accuracy_score(data[batch]['y_train_orig'],\
            np.argmax(optModel.predict(data[batch]['X_train']),axis=-1)))

        # Delete temporary models
        del currModel
        del optModel

    # Return test and training scores
    diffOut = np.subtract(trainOut,testOut)
    for i, diff in enumerate(diffOut):
        if diff < 0.0:
            if abs(diff) < 0.05:
                diffOut[i] = abs(diff)
            else:
                diffOut[i] = 1.0
        
    return np.median(testOut), np.median(diffOut)

# --------------------

def buildCNN_optuna(trial,shape,numClasses,params):

    if params == None:
        # Define the sample space for each hyperparameter:
        params = {
            # Convolution filters and dropout rates
            'numConvBlocks': trial.suggest_int('numConvBlocks',1,3),\
            'conv_filters_1': trial.suggest_int('conv_filters_1',20,49),\
            'conv_filters_2': trial.suggest_int('conv_filters_2',50,79),\
            'conv_filters_3': trial.suggest_int('conv_filters_3',80,109),\
            'dropout_rate_1': trial.suggest_float('dropout_rate_1',0.1,0.9),\
            'dropout_rate_2': trial.suggest_float('dropout_rate_2',0.1,0.9),\
            'dropout_rate_3': trial.suggest_float('dropout_rate_3',0.1,0.9),\
            
            # Whether to use flattening or global max pooling and input layer's dropout rate
            'flatten': trial.suggest_categorical('flatten', [True, False]),\
            'dropout_rate_FC_0': trial.suggest_float('dropout_rate_FC_0',0.1,0.9),\

            # Defines the number of hidden layers, their units, and dropout rates
            'num_hidden_layers': trial.suggest_int('num_hidden_layers',1,2),\
            'hidden_units_FC_1': trial.suggest_int('hidden_units_FC_1',50,150),\
            'hidden_units_FC_2': trial.suggest_int('hidden_units_FC_2',10,100),\
            'dropout_rate_FC_1': trial.suggest_float('dropout_rate_FC_1',0.1,0.9),\
            'dropout_rate_FC_2': trial.suggest_float('dropout_rate_FC_2',0.1,0.9),\

            # Defines the model optimizer, optimizer-specific parameters, and initial learning rates
            'optimizer': trial.suggest_categorical('optimizer', ['Adam', 'SGD']),\
            'lr': trial.suggest_float('lr',1e-5,1e-1,log=True)
        }
               
    # Define sequential framework and input layer for the model
    model = Sequential()
    model.add(Input(shape=shape,dtype="float32"))

    # Add initial downsampling and max pooling
    model.add(AveragePooling3D(pool_size=(2,2,2),data_format="channels_last"))
    model.add(MaxPooling3D(pool_size=(2,2,2)))

    # Add convolution blocks
    for i in range(1,params['numConvBlocks']+1):
        model.add(Conv3D(params[f"conv_filters_{i}"],kernel_size=(3,3,3),activation="elu"))
        model.add(MaxPooling3D(pool_size=(2,2,2)))
        model.add(BatchNormalization(center=True,scale=True))
        model.add(Dropout(params[f"dropout_rate_{i}"]))

    # If not flattening, reduce input features through global max pooling
    if params['flatten']:
        model.add(Flatten())
    else:
        model.add(GlobalMaxPooling3D())
    model.add(Dropout(params[f"dropout_rate_FC_0"]))

    # Add hidden layers
    for i in range(1,params['num_hidden_layers']):
        model.add(Dense(params[f"hidden_units_FC_{i}"],activation="elu"))
        model.add(Dropout(params[f"dropout_rate_FC_{i}"]))
    model.add(Dense(numClasses,activation='softmax'))

    return model

# --------------------

def buildCNN(params,shape):

    # Define sequential framework for the model
    model = Sequential()

    # Add initial downsampling block
    model.add(AveragePooling3D(pool_size=(2,2,2),data_format="channels_last",input_shape=shape))
    model.add(MaxPooling3D(pool_size=(2,2,2)))

    # Add convolution blocks
    for i in range(1,4):
        model = convBlock(model,params[f"conv_filters_{i}"],params[f"dropout_rate_{i}"])

    # Flatten data and create MLP with fully-connected layers (2 hidden)
    model.add(Flatten())
    model.add(Dropout(params[f"dropout_rate_FC_0"]))
    for i in range(1,3):
        model.add(Dense(params[f"hidden_units_FC_{i}"],activation="elu"))
        model.add(Dropout(params[f"dropout_rate_FC_{i}"]))
    model.add(Dense(2,activation='softmax'))

    return model

# --------------------

def convBlock(model,filters,doRate):

    model.add(Conv3D(filters,kernel_size=(3,3,3),activation="elu"))
    model.add(MaxPooling3D(pool_size=(2,2,2)))
    model.add(BatchNormalization(center=True,scale=True))
    model.add(Dropout(doRate))

    return model

# --------------------

def balancedAccuracy(y_true,y_pred):

    '''
    # Option 1:
    # Get single col tensors
    y_pred_updated = K.argmax(y_pred)
    y_true_updated = K.argmax(y_true)

    # Calculate inverse tensors to flip classes
    neg_y_true = 1 - y_true_updated
    neg_y_pred = 1 - y_pred_updated

    # Calculate recall for positive class
    truePos = K.sum(K.round(K.clip(y_true_updated * y_pred_updated, 0, 1)))
    totalPos = K.sum(K.round(K.clip(y_true_updated, 0, 1)))
    recallPos = float(truePos) / float(totalPos)

    # Calculate recall for negative class
    trueNeg = K.sum(K.round(K.clip(neg_y_true * neg_y_pred, 0, 1)))
    totalNeg = K.sum(K.round(K.clip(neg_y_true, 0, 1)))
    recallNeg = float(trueNeg) / float(totalNeg)
    
    # Return the average recall (a.k.a. balanced accuracy)
    return (recallPos+recallNeg) / 2.0
    '''

    '''
    # Option 2:
    # Get the recall of the negative class
    rec_neg = Recall(class_id = 0)
    rec_neg.update_state(y_true,y_pred)
    rec_neg = rec_neg.result().numpy()

    # Get the recall of the positive class
    rec_pos = Recall(class_id = 1)
    rec_pos.update_state(y_true,y_pred)
    rec_pos = rec_pos.result().numpy()

    return (rec_neg+rec_pos)/2.0
    '''

    # Option 3: (best for comparing results with SciKit-Learn's metric)
    y_true_updated = K.argmax(y_true).numpy()
    y_pred_updated = K.argmax(y_pred).numpy()
    return balanced_accuracy_score(y_true_updated,y_pred_updated)

# --------------------

def mergePoolOutput(poolType,poolOut):

    # Merge results from a single round of parameter sampling
    if poolType == "paramSamp":
        scores = []
        epochs = []
        for scoreDict in poolOut:
            scores.append(scoreDict['score'])
            epochs.append(scoreDict['epochs'])
        return [np.median(scores),round(np.median(epochs))]

    # Merge results from the randomized parameter search
    if poolType == "paramSearch":
        bestScore = sys.float_info.max
        bestParams = {}
        bestEpochs = 0
        for scoreDict in poolOut:
            aveEpochs.append(scoreDict['epochs'])
            if scoreDict['score'] > bestScore:
                bestScore = scoreDict['score']
                bestParams = scoreDict['params']
                bestEpochs = scoreDict['epochs']
        return {'score':bestScore,'params':bestParams,'epochs':bestEpochs}

    # Merge results from the randomized parameter search
    if poolType == "eval":
        out = {f"{score}":np.zeros(len(poolOut)) for score in poolOut[0]}
        for i in range(len(poolOut)):
            for score in poolOut[i]:
                out[score][i] = poolOut[i][score]
        return out

# --------------------

def evaluateModel(cvBatches,dvLabel,numSamp_evalFI,numCores_evalFI,prefix):

    print("")
    print("   EVALUATING THE FEATURE LEARNING MODEL")
    print("   ---------------------------------------------------------")
    print("   Analyzing model performance on the training and test sets.")

    # Ensure Tensorflow is no longer using GPUs (memory issues)
    os.environ["CUDA_VISIBLE_DEVICES"] = "-1"

    # Use parallel processing for processing batches of cross validation
    # batchesPool = Parallel(n_jobs=numCores_evalFI)(delayed(permutationTest)(batch=cvBatches[currBatch],\
    #     batchNum=currBatch,modelFile=f"{prefix}/{dvLabel}/models/model_{currBatch}/bestModel_final",\
    #     numSamp_evalFI=numSamp_evalFI) for currBatch in cvBatches)
    batchesPool = [permutationTest(cvBatches[currBatch],currBatch,\
        f"{prefix}/{dvLabel}/models/batch_{currBatch}/bestModel_final",numSamp_evalFI) \
        for currBatch in cvBatches]

    # Output dataframe to save, across all cross validation batches
    outDF = pd.concat(batchesPool)

    # Remove old file if one exists
    if os.path.exists(f"{prefix}/{dvLabel}/featureLearning_CNN_{dvLabel}_evaluation.csv"):
        os.remove(f"{prefix}/{dvLabel}/featureLearning_CNN_{dvLabel}_evaluation.csv")

    # Output data frame to CSV
    outDF.to_csv(f"{prefix}/{dvLabel}/featureLearning_CNN_{dvLabel}_evaluation.csv",sep=',',index=False)

    print('   .....Complete!')

# --------------------

def permutationTest(batch,batchNum,modelFile,numSamp_evalFI):

    # Output dataframe for performance permutation test statistics
    outDF = pd.DataFrame(columns=['BATCH','SET','METRIC','SCORE','P']) 

    for i in ["train","test"]:

        # Define data to use
        X = batch[f'X_{i}']
        y = batch[f'y_{i}_orig']
        evalSet = str(i).upper()
        
        # Get predictions and class probabilities
        currModel = load_model(modelFile,custom_objects={'balancedAccuracy':balancedAccuracy})
        for l in currModel.layers:
            l.trainable = False
        probs = currModel.predict(X)
        preds = np.argmax(probs,axis=-1)
        
        # Define probabilities in the binary case
        if len(probs[0]) < 3:
            probs = np.array([probs[j][1] for j in range(len(probs))])

        # Get scores and probability values for those scores
        scores = getScores(y,preds,probs)
        permuteSamp = [getPermutedScores(currModel,X,y) for samp in range(numSamp_evalFI)]
        permuteMerged = mergePoolOutput("eval",permuteSamp)
        ps = calcPFromDist(scores,"greater than",permuteMerged)
        
        # Append this round of evaluation to output dataframe
        for score in scores:
            outDF = outDF.append({'BATCH':f"{batchNum}",'SET':evalSet,'METRIC':f"{score}",\
                'SCORE':scores[score],'P':ps[score]},ignore_index=True)

    return outDF

# --------------------

def getScores(true,pred,probs):

    return {'balAcc':balanced_accuracy_score(true,pred),\
        'rawAcc':accuracy_score(true,pred),\
        'rocAUC':roc_auc_score(true,probs,average="weighted"),\
        'f1':f1_score(true,pred,average="weighted",zero_division=0),\
        'precision':precision_score(true,pred,average="weighted",zero_division=0),\
        'recall':recall_score(true,pred,average="weighted",zero_division=0),\
        'avePrecis':average_precision_score(true,pred,average="weighted")}

# --------------------

def getPermutedScores(model,data_X,data_y):

    # Make a copy of labels and permute them
    labelsCopy = copy.deepcopy(data_y)
    rng = np.random.RandomState()
    rng.shuffle(labelsCopy)

    # Get prediction probabilities (for AUC of ROC curve)
    probs = model.predict(data_X)
    if len(probs[0]) < 3:
        probs = np.array([probs[j][1] for j in range(len(probs))])

    # Make predictions with the model and score them with the permuted labels
    return getScores(labelsCopy,np.argmax(model.predict(data_X),axis=-1),probs)

# --------------------

def calcPFromDist(scores,side,dists):
    
    out = {}
    for score in scores:
        count = 0
        for i in dists[score]:
            if side == "greater than":
                if i >= scores[score]:
                    count += 1
            else:
                if i <= scores[score]:
                    count += 1
        if count == 0:
            out[score] = str("< "+str(1/len(dists[score])))
        else:
            out[score] = count/len(dists[score])
    return out

# --------------------

def dictToCSV(currDict,fileName):

    # Remove old file if one exists
    if os.path.exists(fileName):
        os.remove(fileName)

    # For sake of ease, convert dictionary to a pandas data frame first
    outDF = pd.DataFrame.from_dict(currDict)

    # Output data frame to CSV
    outDF.to_csv(fileName,sep=',',index=False)

# --------------------

def featureImportance(padding,cvBatches,dvLabel,numCores_evalFI,mapFileDir,prefix):

    expType = "grad"
    print("")
    print("   CALCULATING FEATURE IMPORTANCE USING SHAP")
    print("   ---------------------------------------------------------")
    print("   Generating SHAP maps for each batch of cross validation")
    if expType == "deep":
        print("   DeepExplainer with DeepLIFT algorithm:")
        print("   ...(Shrikumar, Greenside, & Kundaje, 2017; Lundberg & Lee, 2017)")
    elif expType == "grad":
        print("   GradientExplainer with extention of Integrated Gradients algorithm:")
        print("   ...(Sundararajan et al. 2017)")

    # SHAP METHOD
    # Generate SHAP maps for each subject/class
    for i in range(1,len(cvBatches)+1):
        SHAPExplainer(expType,padding,str(i),cvBatches[str(i)],dvLabel,mapFileDir,prefix)

    # SHAP METHOD with PARALLEL COMPUTING
    # Parallel(n_jobs=numCores_evalFI)(delayed(SHAPExplainer)(expType="deep",padding=padding,batchKey=str(i+1),\
    #     batch=cvBatches[str(i+1)],modelName=models[str(i+1)],dvLabel=dvLabel,mapFileDir=mapFileDir,
    #     prefix=prefix) for i in range(len(models)))

    # DEEP EXPLAIN METHOD
    # for i in range(len(models)):
    #     deepExplain("shapley",padding,str(i+1),cvBatches[str(i+1)],models[str(i+1)],dvLabel,mapFileDir,prefix)

    # EPSILON PERTURBATION METHOD
    # for i in range(len(models)):
    #     epsilonPerturbation(padding,str(i+1),cvBatches[str(i+1)],models[str(i+1)],dvLabel,mapFileDir,prefix)

    # Calculate within-class maps (mean) for each class prediction
    aggregateSHAPMaps(cvBatches,"grad",dvLabel,prefix)

    print("")
    print('   .....Complete!')

# --------------------

def SHAPExplainer(expType,padding,batchKey,batch,dvLabel,mapFileDir,prefix):

    if os.path.exists(f"{prefix}/{dvLabel}/SHAP/featureLearning_CNN_{dvLabel}_{expType}SHAP_batch{batchKey}"):
        shapVals = joblib.load(f"{prefix}/{dvLabel}/SHAP/featureLearning_CNN_{dvLabel}_{expType}SHAP_batch{batchKey}")
    else:
        # Ensure Tensorflow is no longer using GPUs (memory issues)
        os.environ["CUDA_VISIBLE_DEVICES"] = "-1"

        # Load the current model
        model = load_model(f"{prefix}/{dvLabel}/models/batch_{batchKey}/bestModel_final",\
            custom_objects={'balancedAccuracy':balancedAccuracy})
        for l in model.layers:
            l.trainable = False

        # Use DeepExplainer:
        if expType == "deep":

            # Select a set of background examples to take an expectation over
            background = batch['X_train']

            # Ensure that the SHAP explainer ignores gradients through the convolution blocks
            # I.e. we're not interested in explaining the downsampled, filtered features;
            # we're only looking to explain the output relative to the input features/voxels
            # (AddV2 refers to passthrough for batch normalization and dropout layers)
            shap.explainers._deep.deep_tf.op_handlers["AvgPool3D"] = shap.explainers._deep.deep_tf.passthrough
            shap.explainers._deep.deep_tf.op_handlers["MaxPool3D"] = shap.explainers._deep.deep_tf.passthrough
            shap.explainers._deep.deep_tf.op_handlers["Conv3D"] = shap.explainers._deep.deep_tf.passthrough
            shap.explainers._deep.deep_tf.op_handlers["AddV2"] = shap.explainers._deep.deep_tf.passthrough
            
            # Explain predictions of the model using the training examples as background
            e = shap.DeepExplainer(model,background)

            # Return the shap values of the test set
            # check_additivity=False prevents failing due to "rounding issues"
            # First check - sum difference = 3.434302, equating to:
            # 3.16*10^-6 per voxel and 0.0381 per input node (90 total) to MLP
            # (We'll consider this a negligable difference)
            shapVals = e.shap_values(batch['X_test'],check_additivity=False)

        # Use GradientExplainer:
        if expType == "grad":

            # Select a set of background examples to take an expectation over
            background = batch['X_train'].copy()
            #background = map2layer(batch['X_train'].copy(),1,model)

            # Explain predictions of the model using the training examples as background
            e = shap.GradientExplainer(model,background)
            #e = shap.GradientExplainer((model.layers[1].input,model.layers[-1].output),background)

            # we explain the model's predictions on the first three samples of the test set
            shapVals = e.shap_values(batch['X_test'])
            #shapVals = e.shap_values(map2layer(batch['X_test'],1,model))

        # Save SHAP values for this test batch
        joblib.dump(shapVals,\
            f"{prefix}/{dvLabel}/SHAP/featureLearning_CNN_{dvLabel}_{expType}SHAP_batch{batchKey}")

    compileSHAPMaps(expType,shapVals,batch['X_train'][0].shape,padding,batch['id_test'],\
        batch['y_test_orig'],dvLabel,mapFileDir,prefix)

# --------------------

def map2layer(x,layer,model):

    feed_dict = dict(zip([model.layers[0].input.ref()], [x.copy()]))
    return K_v1.get_session().run(model.layers[layer].input,feed_dict)

# --------------------

def compileSHAPMaps(expType,shapVals,origShape,padding,batchIDs,batch_y,dvLabel,mapFileDir,prefix):

    # Dim 0: class (2)
    # Dim 1: subj (~ 25 per batch)
    # Dims 2-4: voxel coordinates

    # Iterate subjects in the test batch
    for i, subj in enumerate(batchIDs):

        # Load the original scan for this subject
        orig_img = nib.load(f"{mapFileDir}/{subj}_anat_CAT_GMV_noSmooth_scaledTIV_residScanner_std_gm.nii.gz")

        # Iterate prediction classes for each SHAP map
        for predClass in list(set(batch_y)):

            # If file already exists, remove it
            if not os.path.exists(f"{prefix}/{dvLabel}/SHAP/{subj}_{expType}SHAP_{dvLabel}_{predClass}.nii.gz"):
        
                # Get SHAP values for the input features
                newShapVals = np.array([shapVals[int(predClass)][i]])

                # Upsample SHAP values to the original resolution (input layer shape)
                # Calculate offsets for odd-leveled dimensions
                upsampShapVals = newShapVals[0,0:origShape[0],0:origShape[1],0:origShape[2],0]
                offsets = [np.abs(upsampShapVals.shape[i]-origShape[i]) for i in range(len(origShape)-1)]
                
                # Add the padded 0s back in plus offsets
                paddedShap = np.pad(upsampShapVals,((padding[0],padding[1]+offsets[0]),(padding[2],padding[3]+offsets[1]),\
                    (padding[4],padding[5]+offsets[2])),'constant')

                # Save maps to files
                nib.save(nib.Nifti1Image(paddedShap,orig_img.affine,orig_img.header),\
                    f"{prefix}/{dvLabel}/SHAP/{subj}_{expType}SHAP_{dvLabel}_{predClass}.nii.gz")

# --------------------

def aggregateSHAPMaps(cvBatches,expType,dvLabel,prefix):

    # Get subject IDs for each class
    classes = np.unique(cvBatches['1']['y_train_orig'])
    allSubjs = list(cvBatches['1']['id_train'])+list(cvBatches['1']['id_test'])
    classSubjs = {f"{currClass}":list([]) for currClass in classes}
    for currClass in classes:
        for batch in cvBatches:
            for i,subj in enumerate(cvBatches[batch]['id_test']):
                if cvBatches[batch]['y_test_orig'][i]==currClass:
                    classSubjs[f"{currClass}"].append(f"{subj}")

    for currClass in classes:

        # Calculate mean maps for each class
        for realClass in classes:

            if os.path.exists(f"{prefix}/{dvLabel}/SHAP/MEAN_featureLearning_CNN_{dvLabel}_{realClass}_{expType}SHAP_{currClass}.nii.gz"):
                os.remove(f"{prefix}/{dvLabel}/SHAP/MEAN_featureLearning_CNN_{dvLabel}_{realClass}_{expType}SHAP_{currClass}.nii.gz")

            if not os.path.exists(f"{prefix}/{dvLabel}/SHAP/MEAN_featureLearning_CNN_{dvLabel}_{realClass}_{expType}SHAP_{currClass}.nii.gz"):
                meanCommand = ['3dMean', '-prefix', \
                    f"{prefix}/{dvLabel}/SHAP/MEAN_featureLearning_CNN_{dvLabel}_{realClass}_{expType}SHAP_{currClass}.nii.gz"]
                for ID in classSubjs[f"{realClass}"]:
                    meanCommand.append(f"{prefix}/{dvLabel}/SHAP/{subj}_{expType}SHAP_{dvLabel}_{currClass}.nii.gz")
                subprocess.run(meanCommand)

# --------------------

def deepExplain(expType,padding,batchKey,batch,modelName,dvLabel,mapFileDir,prefix):

    if os.path.exists(f"{prefix}/DeepExplainer/featureLearning_CNN_{dvLabel}_{expType}DE_batch{batchKey}"):
        shapVals = joblib.load(f"{prefix}/DeepExplainer/featureLearning_CNN_{dvLabel}_{expType}DE_batch{batchKey}")
    else:
        # Load the current model
        model = load_model(modelName,custom_objects={'balancedAccuracy':balancedAccuracy})
        for l in model.layers:
            l.trainable = False

        # Use DeepExplain Shapley sampling:
        if expType == "shapley":

            # Init DeepExplain context
            with DeepExplain(session=K.get_session()) as de:
        
                # Need to reconstruct the graph in DeepExplain context, using the same weights.
                # 1. Get the input tensor to the original model
                input_tensor = model.layers[0].input
                
                # 2. Target the output of the last dense layer (pre-softmax)
                # To do so, create a new model sharing the same layers untill the last dense (index -2)
                fModel = Model(inputs=input_tensor,outputs=model.layers[-1].input)
                target_tensor = fModel(input_tensor)
                
                # attributions_gradin = de.explain('grad*input', target_tensor, input_tensor, xs, ys=ys)
                #attributions_sal   = de.explain('saliency', target_tensor, input_tensor, xs, ys=ys)
                #attributions_ig    = de.explain('intgrad', target_tensor, input_tensor, xs, ys=ys)
                #attributions_dl    = de.explain('deeplift', target_tensor, input_tensor, xs, ys=ys)
                #attributions_elrp  = de.explain('elrp', target_tensor, input_tensor, xs, ys=ys)
                #attributions_occ   = de.explain('occlusion', target_tensor, input_tensor, xs, ys=ys)
                
                # Approximate Shapley Values:
                shapVals = de.explain('shapley_sampling',target_tensor,input_tensor,\
                    batch['X_test'],ys=batch['y_test_cat'],samples=100)

        # Save SHAP values for this test batch
        joblib.dump(shapVals,f"{prefix}/DeepExplainer/featureLearning_CNN_{dvLabel}_{expType}DE_batch{batchKey}")

# -------------------- 

def epsilonPerturbation(padding,batchKey,batch,modelName,dvLabel,mapFileDir,prefix):

    # Load the current model
    model = load_model(modelName,custom_objects={'balancedAccuracy':balancedAccuracy})
    for l in model.layers:
        l.trainable = False

    # Get a (very small) epsilon value to use
    eps = chooseEpsilon(batch,model,50,10)

    # Get results output map
    results = copy.deepcopy(batch['X_train'][0])[:,:,:,0]

    # Combine training and testing instances
    batchAll_X = np.concatenate((batch['X_train'],batch['X_test']))
    batchAll_y = np.concatenate((batch['y_train_cat'],batch['y_test_cat']))

    # Get unperturbed loss
    origLoss = model.evaluate(x=batchAll_X,y=batchAll_y,batch_size=len(batchAll_X))[0]
    
    # Iterate through all coordinates in the map
    for x in range(len(results)):
        for y in range(len(results[x])):
            for z in range(len(results[x][y])):
                if results[x][y][z] != 0:

                    # If there is data present, perturb the voxel, calculate change in loss, and save gradient
                    copyTrain = copy.deepcopy(batchAll_X)
                    pertTrain = perturbCoordWithEpsilon(copyTrain,[x,y,z],eps)
                    pertLoss = model.evaluate(x=pertTrain,y=batchAll_y,batch_size=len(pertTrain))[0]
                    results[x][y][z] = np.abs(pertLoss - origLoss)/eps

    # Save these epsilon perturbation values
    joblib.dump(results,f"{prefix}/EpsilonPert/featureLearning_CNN_{dvLabel}_EpsPert_batch{batchKey}")

    # Pad perturbation values with necesary zeros, and save as a map
    subj = batch['id_train'][0]
    orig_img = nib.load(f"{mapFileDir}/{subj}_anat_CAT_GMV_noSmooth_scaledTIV_residScanner_std.nii.gz")
    paddedEps = np.pad(results,((padding[0],padding[1]),(padding[2],padding[3]),\
        (padding[4],padding[5])),'constant')
    new_img = nib.Nifti1Image(paddedEps,orig_img.affine,orig_img.header)
    nib.save(new_img,f"{prefix}/EpsilonPert/featureLearning_CNN_{dvLabel}_EpsPert_batch{batchKey}.nii.gz") 

# -------------------- 

def chooseEpsilon(batch,model,nSamp,nEps):

    # Choose random (but slightly larger) initial epsilon value
    ep = 1000

    # Combine training and testing instances
    batchAll_X = np.concatenate((batch['X_train'],batch['X_test']))
    batchAll_y = np.concatenate((batch['y_train_cat'],batch['y_test_cat']))

    # Get unperturbed loss
    origLoss = model.evaluate(x=batchAll_X,y=batchAll_y,batch_size=len(batchAll_X))[0]

    # Create output container for epsilon simulations
    epSimOut = {'eps':list([]),'meanDelta':list([])}

    # Perturb 'nSamp' random voxels using the current epsilon value
    # Evaluate perturbed model, save epsilon and change in loss
    dataShape = batch['X_train'][0].shape
    rng = np.random.RandomState()

    # Repeat for different values of epsilon
    for numEp in range(nEps):

        # Container for loss changes
        deltas = [0.0 for samp in range(nSamp)]

        # Repeat for a random sample of voxels
        for samp in range(nSamp):

            # Continue until a non-zero voxel is randomly chosen
            stillZero = True
            while stillZero:

                # Get random coordinate/voxel
                rand1 = rng.randint(dataShape[0])
                rand2 = rng.randint(dataShape[1])
                rand3 = rng.randint(dataShape[2])

                # Check if the data value is 0 (if so, continue trying)
                # If it isn't, purturb the batch/coordinate with the epsilon value
                if batch['X_train'][0][rand1,rand2,rand3,0] != 0:
                    stillZero = False
                    perturbed = perturbCoordWithEpsilon(batchAll_X,[rand1,rand2,rand3],ep) 
                    pertLoss = model.evaluate(x=perturbed,y=batchAll_y,batch_size=len(batchAll_X))[0]
                    
                    # Calculate change in loss
                    deltas[samp] = pertLoss - origLoss

        # Append the epsilon value, mean change in loss, and decrease epsilon for the next round
        epSimOut['eps'].append(ep)
        epSimOut['meanDelta'].append(np.mean(deltas))
        ep = ep / 10

    return findMinConvergedEpsilon(epSimOut)

# -------------------- 

def perturbCoordWithEpsilon(trainBatch,coords,ep):

    newBatch = []
    for subj in trainBatch:
        new = copy.deepcopy(subj)
        new[coords[0]][coords[1]][coords[2]] = subj[coords[0]][coords[1]][coords[2]] + ep
        newBatch.append(new)
    
    return np.array(newBatch)

# -------------------- 

def findMinConvergedEpsilon(epSims):

    # Get changes for each epsilon step
    deltas = list([])
    newEps = epSims['eps'][1:]
    for i in range(len(newEps)):
        if i != len(newEps)-1:
            first = epSims['meanDelta'][i+1]-epSims['meanDelta'][i]
            second = epSims['meanDelta'][i+2]-epSims['meanDelta'][i+1]
            deltas.append((np.abs(first)+np.abs(second))/2)
        else:
            deltas.append(np.abs(epSims['meanDelta'][i+1]-epSims['meanDelta'][i]))

    # Sort the lists in descending order based on delta and define ranks
    deltas, newEps = (list(t) for t in zip(*sorted(zip(deltas, newEps),reverse=True)))
    ranks = list(range(1,len(deltas)+1))

    # Get the 'elbow index' of the change in deltas
    p1 = np.asarray((ranks[0],deltas[0]))
    p2 = np.asarray((ranks[len(ranks)-1],deltas[len(ranks)-1]))
    maxIndex = np.argmax([np.linalg.norm(np.cross(p2-p1,p1-np.asarray((ranks[i],deltas[i]))))/np.linalg.norm(p2-p1) \
        for i in range(0,len(ranks))])

    # Get minimal epsilon after point of convergence
    bestEps = 1000
    for i in range(maxIndex,len(newEps)):
        if newEps[i] < bestEps:
            bestEps = newEps[i]
    return bestEps

# -----------------------------------------------------------------------------------------------------------------------
# MAIN:
# -----------------------------------------------------------------------------------------------------------------------

if __name__ == '__main__':

    print("")
    print("-----------------------------------------------------------------------------")
    print("     MODELING for FEATURE LEARNING using a CONVOLUTIONAL NEURAL NETWORK      ")
    print("-----------------------------------------------------------------------------")
    print("")
    print("   Intended for use with .nii neuroimaging data and currently includes:")
    print("   1. Model optimization and training")
    print("   2. Model evaluation with permutation testing")
    print("   3. Feature importance with SHAP values")

    # Get data from args
    readIn = check_args_read_data(sys.argv)
    subjData = readIn['subjData'] # Dict with subject IDs and label lists
    mapFileDir = readIn['mapFileDir'] # Directory where maps are located
    prefix = readIn['prefix'] # Prefix for output files
    dvLabel = readIn['dvLabel'] # Dependent variable label for prediction (also to find previously optimized/trained models)
    kCV_MB = readIn['kCV_MB'] # Number of folds of cross validation for parameter tuning
    numSamp_MB = readIn['numSamp_MB'] # Number of sampled parameter sets for model building
    numSamp_evalFI = readIn['numSamp_evalFI'] # Number of sampled permutations for evaluation, feature importance metrics
    numCores_MB = readIn['numCores_MB'] # Number of parallel cores for model building 
    numCores_evalFI = readIn['numCores_evalFI'] # Number of parallel cores for evalution, feature importance

    # If brain padding file exists, load it; else, create it
    print("   Attempting to find previous padding file and cross validation batches...")
    if os.path.exists(f"{prefix}/{dvLabel}/featureLearning_CNN_{dvLabel}_padding") and \
        os.path.exists(f"{prefix}/{dvLabel}/featureLearning_CNN_{dvLabel}_cvBatches_CV{kCV_MB}"):
        print("   Previous padding file and batches were found! Loading in data...")
        padding = joblib.load(f"{prefix}/{dvLabel}/featureLearning_CNN_{dvLabel}_padding")
        cvBatches = joblib.load(f"{prefix}/{dvLabel}/featureLearning_CNN_{dvLabel}_cvBatches_CV{kCV_MB}")
        print("")
    else:
        print("   Previous padding file and batches were not found. Loading in data...")
        allBrainData = readNIFTI(subjData['subj'],mapFileDir)
        padding = allBrainData['padding']
        subjData['data'] = formatSetData(allBrainData['trimmed_data'],subjData['label'])
        cvBatches = getCVBatches(kCV_MB,subjData)
        if not os.path.exists(f"{prefix}/{dvLabel}/featureLearning_CNN_{dvLabel}_cvBatches_CV{kCV_MB}"):
            joblib.dump(cvBatches,f"{prefix}/{dvLabel}/featureLearning_CNN_{dvLabel}_cvBatches_CV{kCV_MB}")
        if not os.path.exists(f"{prefix}/{dvLabel}/featureLearning_CNN_{dvLabel}_padding"):
            joblib.dump(padding,f"{prefix}/{dvLabel}/featureLearning_CNN_{dvLabel}_padding")
        
    # If previous optimized params exist, load them; else, create them
    print("   Attempting to find previously optimized model parameters...")
    if not os.path.exists(f"{prefix}/{dvLabel}/optuna"):
        subprocess.run(['mkdir',f"{prefix}/{dvLabel}/optuna"])
    if not os.path.exists(f"{prefix}/{dvLabel}/models"):
        subprocess.run(['mkdir',f"{prefix}/{dvLabel}/models"])
    toBuild = [f"{batch}" for batch in range(1,kCV_MB+1) \
        if not os.path.exists(f"{prefix}/{dvLabel}/optuna/batch_{batch}/trials_out") or \
            not os.path.exists(f"{prefix}/{dvLabel}/models/batch_{batch}/bestModel_final")]
    if toBuild:
        print('   .....Optimizing hyperparameters for missing batches:')
        print(f"   {toBuild}")
        mbStartTime = datetime.now()
        tuneFLModels(kCV_MB,cvBatches,dvLabel,prefix,toBuild,numSamp_MB,numCores_MB)
        print("   Total time for model parameter optimization: "+str(datetime.now() - mbStartTime))
    else:
        print('   .....All optimized models found!')
    print("")

    # Run model evaluation
    print("   Start model evaluation...")
    if not os.path.exists(f"{prefix}/{dvLabel}/featureLearning_CNN_{dvLabel}_evaluation.csv"):
        evalStartTime = datetime.now()
        evaluateModel(cvBatches,dvLabel,numSamp_evalFI,numCores_evalFI,prefix)
        print("")
        print("   Total time for model evalutation: "+str(datetime.now() - evalStartTime))
    else:
        print("   .....Found previous evaluation file.")
    print("")
        
    # Create feature importance maps for the models
    print("   Start feature importance analysis...")
    fiStartTime = datetime.now()
    featureImportance(padding,cvBatches,dvLabel,numCores_evalFI,mapFileDir,prefix)
    print("")
    print("   Total time for feature importance analysis: "+str(datetime.now() - fiStartTime))
    print("")

    print("-----------------------------------------------------------------------------")
    print("                            ALL ANALYSES COMPLETE!                           ")
    print("               Total Execution Time: "+str(datetime.now() - startTime)+"          ")
    print("-----------------------------------------------------------------------------")
    print("")

# -----------------------------------------------------------------------------------------------------------------------
# END MAIN
# -----------------------------------------------------------------------------------------------------------------------