import tensorflow
import tensorflow.keras.backend as K
from tensorflow.keras.models import load_model
from sklearn.metrics import balanced_accuracy_score
import sys

def balancedAccuracy(y_true,y_pred):
    y_true_updated = K.argmax(y_true).numpy()
    y_pred_updated = K.argmax(y_pred).numpy()
    return balanced_accuracy_score(y_true_updated,y_pred_updated)

pred = sys.argv[1]
baseDir = f"/Volumes/Vol6/YouthPTSD/data/t1resiliency/allsubj/mri/CNN_featureLearning_proc/out/{pred}/models"

for batchNum in [2,3,4,5,6,7,8,9,10]:
    num_conv = 0
    filters_1 = 0
    filters_2 = 0
    filters_3 = 0
    dr_1 = 0
    dr_2 = 0
    dr_3 = 0
    flat = False
    num_h = 0
    h_1 = 0
    h_2 = 0
    dr_mlp_1 = 0
    dr_mlp_2 = 0
    dr_mlp_3 = 0
    opt = 0
    lr = 0
    currModel = load_model(f"{baseDir}/batch_{batchNum}/bestModel_final",custom_objects={'balancedAccuracy':balancedAccuracy})
    layerConfig = currModel.get_config()['layers']

    for numLayer,layer in enumerate(layerConfig):
        # Get convolution parameters
        if layer['class_name']=="Conv3D":
            num_conv += 1
            if filters_1 == 0:
                filters_1 = layer['config']['filters']
            else:
                if filters_2 == 0:
                    filters_2 = layer['config']['filters']
                else:
                    filters_3 = layer['config']['filters']
        if layer['class_name']=="Flatten":
            flat = True
        if layer['class_name']=="Dense":
            if layer['config']['units'] != 2:
                num_h += 1
                if h_1 == 0:
                    h_1 = layer['config']['units']
                else:
                    h_2 = layer['config']['units']
        if layer['class_name']=="Dropout":
            if layerConfig[numLayer-1]['class_name']=="BatchNormalization":
                if dr_1 == 0:
                    dr_1 = layer['config']['rate']
                else:
                    if dr_2 == 0:
                        dr_2 = layer['config']['rate']
                    else:
                        dr_3 = layer['config']['rate']
            else:
                if dr_mlp_1 == 0:
                    dr_mlp_1 = layer['config']['rate']
                else:
                    if dr_mlp_2 == 0:
                        dr_mlp_2 = layer['config']['rate']
                    else:
                        dr_mlp_3 = layer['config']['rate']

    # Get optimizer-specific hyperparams
    optConfig = currModel.optimizer.get_config()
    opt = optConfig['name']
    lr = optConfig['learning_rate']

    print("")
    print(f"BATCH {batchNum}")
    print("")
    print(layerConfig)
    print("")
    print(f"Num conv filters: {num_conv}")
    print(f"filters 1: {filters_1}")
    print(f"filters 2: {filters_2}")
    print(f"filters 3: {filters_3}")
    print(f"dropout 1: {dr_1}")
    print(f"dropout 2: {dr_2}")
    print(f"dropout 3: {dr_3}")
    print(f"flatten: {flat}")
    print(f"num hidden: {num_h}")
    print(f"units 1: {h_1}")
    print(f"units 2: {h_2}")
    print(f"dropout h 1: {dr_mlp_1}")
    print(f"dropout h 2: {dr_mlp_2}")
    print(f"dropout h 3: {dr_mlp_3}")
    print(f"optimizer: {opt}")
    print(f"learning rate: {lr}")
    print("")