# Python:
import copy
import sys

# Scikit-Learn:
import sklearn
from sklearn.metrics import balanced_accuracy_score
from sklearn.utils import compute_class_weight

# Numpy:
import numpy as np

# Tensorflow
import tensorflow as tf
tf.compat.v1.disable_eager_execution()
tf.compat.v1.disable_v2_behavior()

# Keras:
import keras
import tensorflow.compat.v1.keras.backend as K
tf.keras.backend.set_floatx('float64')
from keras.models import Sequential,load_model,Model
from keras.layers import Input,Dense,Flatten,Conv3D,MaxPooling3D,AveragePooling3D,GlobalMaxPooling3D,\
    Dropout,BatchNormalization,Concatenate
from keras.activations import elu
from keras.optimizers import Adam, SGD
from keras.utils import np_utils
from keras import backend as K
 
# ConfigSpace:
import ConfigSpace as CS
import ConfigSpace.hyperparameters as CSH

# HpBandster:
from hpbandster.core.worker import Worker

class KerasWorker(Worker):

    allData = None # Should contain cross validation batches
    numClasses = None
    batchSize = None
    def __init__(self,data,numClasses,batchSize,**kwargs):
        super().__init__(**kwargs)
        self.allData = data
        self.numClasses = numClasses
        self.batchSize = batchSize

    def compute(self,config,budget,working_directory,*args,**kwargs):

        # Define sequential framework and input layer for the model
        model = Sequential()
        model.add(Input(shape=self.allData['1']['X_train'][0].shape,dtype="float32"))

        # Add initial downsampling block, otherwise just max pooling
        if config['initialResamp']:
            model.add(AveragePooling3D(pool_size=(2,2,2),data_format="channels_last"))
            model.add(MaxPooling3D(pool_size=(2,2,2)))
        else:
            model.add(MaxPooling3D(pool_size=(2,2,2),data_format="channels_last"))

        # Add convolution blocks
        for i in range(1,config['numConvBlocks']+1):
            model.add(Conv3D(config[f"conv_filters_{i}"],kernel_size=(3,3,3),activation="elu"))
            model.add(MaxPooling3D(pool_size=(2,2,2)))
            model.add(BatchNormalization(center=True,scale=True))
            model.add(Dropout(config[f"dropout_rate_{i}"]))

        # If not flattening, reduce input features through global max pooling
        if config['flatten']:
            model.add(Flatten())
        else:
            model.add(GlobalMaxPooling3D())
        model.add(Dropout(config[f"dropout_rate_FC_0"]))

        # Add hidden layers
        for i in range(1,config['num_hidden_layers']):
            model.add(Dense(config[f"hidden_units_FC_{i}"],activation="elu"))
            model.add(Dropout(config[f"dropout_rate_FC_{i}"]))
        model.add(Dense(self.numClasses,activation='softmax'))

        # Choose optimizer
        if config['optimizer'] == 'Adam':
            optimizer = keras.optimizers.Adam(lr=config['lr'])
        else:
            optimizer = keras.optimizers.SGD(lr=config['lr'],momentum=config['sgd_momentum'])

        # Compile the model
        model.compile(loss="binary_crossentropy",optimizer=optimizer,metrics=[self.balancedAccuracy])

        # Run cross validation for the current model
        trainOut = []
        testOut = []
        for batch in self.allData:

            # Create a copy of the model
            currModel = keras.models.clone_model(model)
            currModel.build(self.allData['1']['X_train'][0].shape)
            currModel.compile(loss="binary_crossentropy",optimizer=optimizer,metrics=[self.balancedAccuracy])
            currModel.set_weights(model.get_weights())

            # Compute class weights to ensure classifier isn't guessing majority class
            classWeight = compute_class_weight('balanced',np.unique(self.allData[batch]['y_train_orig']),\
                self.allData[batch]['y_train_orig']) 
            classWeight = dict(enumerate(classWeight))

            # Fit the model
            currModel.fit(self.allData[batch]['X_train'],self.allData[batch]['y_train'],batch_size=self.batchSize,\
                epochs=int(budget),verbose=0,validation_data=(self.allData[batch]['X_test'],\
                self.allData[batch]['y_test']),shuffle=True,class_weight=classWeight)

            # Get scores
            trainOut.append(balanced_accuracy_score(self.allData[batch]['y_train_orig'],\
                np.argmax(currModel.predict(self.allData[batch]['X_train']),axis=-1)))
            testOut.append(balanced_accuracy_score(self.allData[batch]['y_test_orig'],\
                np.argmax(currModel.predict(self.allData[batch]['X_test']),axis=-1)))

            # Delete the copied model immediately for space efficiency
            del currModel

        #import IPython; IPython.embed()
        return ({'loss': 1-np.median(testOut), # remember: HpBandSter always minimizes!
                'info': {'test_CV_balAcc': np.median(testOut),'train_CV_balAcc': np.median(trainOut),
                    'numParams': model.count_params()}})

    @staticmethod
    def balancedAccuracy(y_true,y_pred):

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

    @staticmethod
    def get_configspace(): 
        """
        It builds the configuration space with the needed hyperparameters.
        """
        # Define the hyperparameter object
        cs = CS.ConfigurationSpace()

        # Define the sample space for each hyperparameter:
        # Initial downsample of input features
        initialResamp = CSH.CategoricalHyperparameter('initialResamp', [True, False])

        # Number of convolution blocks, their filters, and dropout rates
        numConvBlocks = CSH.UniformIntegerHyperparameter('numConvBlocks',lower=1,upper=4,default_value=3,log=False)
        conv_filters_1 = CSH.UniformIntegerHyperparameter('conv_filters_1',lower=20,upper=49,default_value=30,log=False)
        conv_filters_2 = CSH.UniformIntegerHyperparameter('conv_filters_2',lower=50,upper=79,default_value=60,log=False)
        conv_filters_3 = CSH.UniformIntegerHyperparameter('conv_filters_3',lower=80,upper=109,default_value=90,log=False)
        conv_filters_4 = CSH.UniformIntegerHyperparameter('conv_filters_4',lower=110,upper=140,default_value=120,log=False)
        dropout_rate_1 = CSH.UniformFloatHyperparameter('dropout_rate_1',lower=0.1,upper=0.9,default_value=0.5,log=False)
        dropout_rate_2 = CSH.UniformFloatHyperparameter('dropout_rate_2',lower=0.1,upper=0.9,default_value=0.5,log=False)
        dropout_rate_3 = CSH.UniformFloatHyperparameter('dropout_rate_3',lower=0.1,upper=0.9,default_value=0.5,log=False)
        dropout_rate_4 = CSH.UniformFloatHyperparameter('dropout_rate_4',lower=0.1,upper=0.9,default_value=0.5,log=False)
        
        # Whether to use flattening or global max pooling and input layer's dropout rate
        flatten = CSH.CategoricalHyperparameter('flatten', [True, False])
        dropout_rate_FC_0 = CSH.UniformFloatHyperparameter('dropout_rate_FC_0',lower=0.1,upper=0.9,default_value=0.5,log=False)

        # Defines the number of hidden layers, their units, and dropout rates
        num_hidden_layers = CSH.UniformIntegerHyperparameter('num_hidden_layers',lower=1,upper=2,default_value=2,log=False)
        hidden_units_FC_1 = CSH.UniformIntegerHyperparameter('hidden_units_FC_1',lower=50,upper=150,default_value=100,log=False)
        hidden_units_FC_2 =CSH.UniformIntegerHyperparameter('hidden_units_FC_2',lower=10,upper=100,default_value=50,log=False)
        dropout_rate_FC_1 = CSH.UniformFloatHyperparameter('dropout_rate_FC_1',lower=0.1,upper=0.9,default_value=0.5,log=False)
        dropout_rate_FC_2 = CSH.UniformFloatHyperparameter('dropout_rate_FC_2',lower=0.1,upper=0.9,default_value=0.5,log=False)

        # Defines the model optimizer, optimizer-specific parameters, and initial learning rates
        optimizer = CSH.CategoricalHyperparameter('optimizer', ['Adam', 'SGD'])
        lr = CSH.UniformFloatHyperparameter('lr', lower=1e-5, upper=1e-1, default_value='1e-2', log=True)
        sgd_momentum = CSH.UniformFloatHyperparameter('sgd_momentum', lower=0.0, upper=0.99, default_value=0.9, log=False)

        # Add all hyperparameters to object
        cs.add_hyperparameters([initialResamp,numConvBlocks,conv_filters_1,conv_filters_2,conv_filters_3,\
            conv_filters_4,dropout_rate_1,dropout_rate_2,dropout_rate_3,dropout_rate_4,flatten,dropout_rate_FC_0,\
            num_hidden_layers,hidden_units_FC_1,hidden_units_FC_2,dropout_rate_FC_1,dropout_rate_FC_2,\
            optimizer,lr,sgd_momentum])

        # The hyperparameter sgd_momentum will be used,if the configuration contains 'SGD' as optimizer.
        optCond = CS.EqualsCondition(sgd_momentum, optimizer, 'SGD')

        # Ensure parameters are only used if appropriate number of layers
        convCond_1 = CS.GreaterThanCondition(conv_filters_2,numConvBlocks,1)
        convCond_2 = CS.GreaterThanCondition(conv_filters_3,numConvBlocks,2)
        convCond_3 = CS.GreaterThanCondition(conv_filters_4,numConvBlocks,3)
        doCond_1 = CS.GreaterThanCondition(dropout_rate_2,numConvBlocks,1)
        doCond_2 = CS.GreaterThanCondition(dropout_rate_3,numConvBlocks,2)
        doCond_3 = CS.GreaterThanCondition(dropout_rate_4,numConvBlocks,3)
        unitsCond_1 = CS.GreaterThanCondition(hidden_units_FC_2,num_hidden_layers,1)
        doFCCond_1 = CS.GreaterThanCondition(dropout_rate_FC_2,num_hidden_layers,1)

        # Compile conditions
        for cond in [optCond,convCond_1,convCond_2,convCond_3,doCond_1,doCond_2,doCond_3,unitsCond_1,doFCCond_1]:
            cs.add_condition(cond)

        # Do not use a 4th convolution block if initial downsampling has been done
        forbidden_clause_a = CS.ForbiddenEqualsClause(initialResamp,True)
        forbidden_clause_b = CS.ForbiddenEqualsClause(numConvBlocks,4)
        forbidden_clause = CS.ForbiddenAndConjunction(forbidden_clause_a, forbidden_clause_b)
        cs.add_forbidden_clause(forbidden_clause)

        return cs