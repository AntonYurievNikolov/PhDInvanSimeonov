from sklearn import datasets
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
# to ignore the warnings  
from warnings import filterwarnings 
  

#df = pd.read_csv("train.csv")
df = sns.load_dataset('tips') 

# the first five entries of the dataset 
df.head() 
#Histogram
sns.set_style('whitegrid') 
sns.distplot(df['total_bill'], kde = False, color ='red', bins = 30) 