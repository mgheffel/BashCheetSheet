import sys
import numpy as np
import pandas as pd
import pickle
import math

import matplotlib.pyplot as plt
from sklearn import metrics
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression

siteIndex=int(sys.argv[1])
xTisToPred=sys.argv[2]

probesDF=pd.read_csv("all_probes.csv").set_index('CGid').transpose()
siteCols=probesDF.columns
#print(probesDF.shape)
probesDF.head(5)
#print(len(siteCols))

#these are just the dataframe from reading datSampleCombinedfinal_primates_noN33.csv paritioned by species
#only blood and liver are being used for now
humanTissueDFs={}
humanTissueDFs["Liver"]=pd.read_pickle("oneHotEncoded_HumanLiverLabels.pickle")
infoCols=humanTissueDFs["Liver"].columns
#print(infoCols)
humanTissueDFs["Heart"]=pd.read_pickle("oneHotEncoded_HumanHeartLabels.pickle")
humanTissueDFs["Adipose"]=pd.read_pickle("oneHotEncoded_HumanAdiposeLabels.pickle")
humanTissueDFs["Muscle"]=pd.read_pickle("oneHotEncoded_HumanMuscleLabels.pickle")
humanTissueDFs["Cerebellum"]=pd.read_pickle("oneHotEncoded_HumanCerebellumLabels.pickle")
humanTissueDFs["Cortex"]=pd.read_pickle("oneHotEncoded_HumanCortexLabels.pickle")
humanTissueDFs["Cortex"].head(5)

if xTisToPred not in humanTissueDFs.keys():
    print("Tissue not in dataset")
    exit()

for tissue in humanTissueDFs.keys():
    humanTissueDFs[tissue]=humanTissueDFs[tissue].join(probesDF)

humanTissueDFs["Liver"].head(5)

def normalize(features):
    data = features.values
    scale = np.amax(np.absolute(data), axis=0)

    scale = np.where(scale == 0, 1, scale)
    
    normalized_features = pd.DataFrame(data/scale, index=features.index, columns=features.columns)

    return [normalized_features, scale.reshape(1, scale.shape[0])]
def normalize_select_columns(features, columns_to_normalize):
    for column in columns_to_normalize:
        column_contents = features[column].values
        scale = np.amax(np.absolute(column_contents))
        features[column] = column_contents/scale

    return features


for tissue in humanTissueDFs.keys():
    humanTissueDFs[tissue]=normalize_select_columns(humanTissueDFs[tissue], ['Age','ConfidenceInAgeEstimate'])
humanTissueDFs["Heart"].head(5)


for tissue in humanTissueDFs.keys():
    print(tissue)
    print(humanTissueDFs[tissue].shape)
#equal representations
humanTissueDFs["Liver"]=humanTissueDFs["Liver"][:33]
humanTissueDFs["Heart"]=humanTissueDFs["Heart"][:33]
humanTissueDFs["Adipose"]=humanTissueDFs["Adipose"][:33]
humanTissueDFs["Muscle"]=humanTissueDFs["Muscle"][:33]


#for i in range(len(siteCols)):
cgSiteDF={}
i=siteIndex
t2=xTisToPred
for tissue in humanTissueDFs.keys():
    if t2==tissue: continue
    for index,row in humanTissueDFs[tissue].iterrows():
        entry=row
        for i2,r2 in humanTissueDFs[t2].iterrows():
            entry['y']=r2[siteCols[i]]
            for infoCol in infoCols:
                entry["target_"+infoCol]=r2[infoCol]
            cgSiteDF[entry.name+"_"+r2.name]=entry.copy()

cgSiteDF=pd.DataFrame.from_dict(cgSiteDF).transpose()
print(cgSiteDF.shape)
y=cgSiteDF.pop("y")
X=cgSiteDF

X_train, X_test, y_train, y_test = train_test_split(X,y,test_size=0.25,random_state=42)
model=LinearRegression()
model.fit(X_train,y_train)
predictions=model.predict(X_test)
#modelDict[tissue][siteCols[i]]={}
#modelDict[tissue][siteCols[i]]["model"]=model
#modelDict[tissue][siteCols[i]]["Score"]=str(model.score(X_test,y_test))
print(siteCols[siteIndex])
print(xTisToPred+"_MSE: "+str(metrics.mean_squared_error(y_test,predictions)))
print(xTisToPred+"_MAE: "+str(metrics.mean_absolute_error(y_test,predictions)))
print(xTisToPred+"_Max Error: "+str(metrics.max_error(y_test,predictions)))
print(xTisToPred+"_r2: "+str(metrics.r2_score(y_test,predictions)))
with open(xTisToPred.lower()+"_first1k/"+xTisToPred.lower()+"_"+siteCols[siteIndex]+"_info.txt",'w')as f:
    f.write(xTisToPred+"_"+siteCols[siteIndex]+"_MSE: "+str(metrics.mean_squared_error(y_test,predictions))+"\n")
    f.write(xTisToPred+"_"+siteCols[siteIndex]+"_MAE: "+str(metrics.mean_absolute_error(y_test,predictions))+"\n")
    f.write(xTisToPred+"_"+siteCols[siteIndex]+"_Max Error: "+str(metrics.max_error(y_test,predictions))+"\n")
    f.write(xTisToPred+"_"+siteCols[siteIndex]+"_r2: "+str(metrics.r2_score(y_test,predictions))+"\n")

#modelDict[tissue][siteCols[i]]["y"]=y_test
#modelDict[tissue][siteCols[i]]["y_pred"]=predictions
#pickle.dump(cgSiteDF,open("cgSiteDF.pickle","wb"))
