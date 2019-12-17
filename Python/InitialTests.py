#from sklearn import datasets
from sklearn import preprocessing
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
from statsmodels.graphics.gofplots import qqplot

#df = pd.read_csv("train.csv")
df = pd.read_csv("Data.csv") 

# the first five entries of the dataset 
df.describe()

cols = list(df.columns)
toRemove = ['Methodology','Name','Age']

for col in toRemove:
    cols.remove(col)

dfScaled = df[cols].copy()

invert = ["30m sprint","4x10m shuttle","Box Drill ","Dribble strong","Dribble weak"]

              
dfScaled['TotalScore'] = 0

for col in cols:
    if (invert.__contains__(col)) :
        dfScaled[col] =  -1*stats.zscore(df[col]) 
      
    else:
        dfScaled[col] =  stats.zscore(df[col])#(df[col] - df[col].mean())/df[col].std(ddof=0)
    
    dfScaled['TotalScore'] = dfScaled[col]  +  dfScaled['TotalScore']
dfScaled['Name'] = df['Name']

dfScaled['TotalScore'] = dfScaled['TotalScore']/len(cols)



sns.distplot(dfScaled['TotalScore'], kde=True, rug=True);
#Check normality
qqplot(dfScaled['TotalScore'], line='s')
pyplot.show()

#Sharpio Wiki Test
from scipy.stats import shapiro
stat, p = shapiro(dfScaled['TotalScore'])
print('Statistics=%.3f, p=%.3f' % (stat, p))
alpha = 0.05
if p > alpha:
	print('Sample looks Gaussian (fail to reject H0)')
else:
	print('Sample does not look Gaussian (reject H0)')

#D’Agostino’s K^2 Test
from scipy.stats import normaltest
stat, p = normaltest(dfScaled['TotalScore'])
print('Statistics=%.3f, p=%.3f' % (stat, p))
# interpret
alpha = 0.05
if p > alpha:
	print('Sample looks Gaussian (fail to reject H0)')
else:
	print('Sample does not look Gaussian (reject H0)')
    
from scipy.stats import kurtosis
from scipy.stats import skew

plt.style.use('ggplot')


plt.hist(dfScaled['TotalScore'], bins=60)
plt.show()
print("mean : ", np.mean(dfScaled['TotalScore']))
print("var  : ", np.var(dfScaled['TotalScore']))
print("skew : ",skew(dfScaled['TotalScore']))
print("kurt : ",kurtosis(dfScaled['TotalScore']))

#Anderson-Darling Test
result = stats.anderson(dfScaled['TotalScore'], dist='norm')
print('Statistic: %.3f' % result.statistic)
p = 0
for i in range(len(result.critical_values)):
	sl, cv = result.significance_level[i], result.critical_values[i]
	if result.statistic < result.critical_values[i]:
		print('%.3f: %.3f, data looks normal (fail to reject H0)' % (sl, cv))
	else:
		print('%.3f: %.3f, data does not look normal (reject H0)' % (sl, cv))
        
