from sklearn import datasets
from sklearn import preprocessing
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
# to ignore the warnings  
from warnings import filterwarnings 
  

#df = pd.read_csv("train.csv")
df = pd.read_csv("Data.csv") 

# the first five entries of the dataset 
df.describe()

cols = list(df.columns)
toRemove = ['Methodology','Name','Age']

for col in toRemove:
    cols.remove(col)

dfScaled = df[cols].copy()

dfScaled['TotalScore'] = 0
for col in cols:
    dfScaled[col] =  stats.zscore(df[col]) #(df[col] - df[col].mean())/df[col].std(ddof=0)
    dfScaled['TotalScore'] = dfScaled[col]  +  dfScaled['TotalScore']
dfScaled['Name'] = df['Name']

dfScaled['TotalScore'] = dfScaled['TotalScore']/len(cols)



sns.distplot(dfScaled['TotalScore'], kde=True, rug=True);