#!/usr/bin/env python
# coding: utf-8

# In[3]:


#imports
import pandas as pd 
import subprocess
import numpy as np
import matplotlib.pyplot as plt
import seaborn


# In[ ]:


os.system("sh fileConversion.sh")


# In[ ]:


os.system("sh filter_recode.sh")


# In[4]:


os.system("sh bgzip.sh")


# In[ ]:


os.system("sh mergevcfs.sh")


# In[ ]:


os.system("sh runPCA.sh")


# In[2]:


#eigvec and eigval in dataframes
eigVec=pd.read_csv('mergedchromosomesPCA.eigenvec', header=None, sep='\s+')
eigVal=pd.read_csv('mergedchromosomesPCA.eigenval', header=None)
eigVec=eigVec.drop(columns=0)
eigVec.columns = ['SampleName','PC1','PC2','PC3','PC4','PC5','PC6','PC7','PC8', 'PC9','PC10']
eigVec.head()


# In[5]:


#tsv table to incorporate w/ PCA visualization
igsr = pd.read_csv("igsr_samples.tsv", sep='\t')
igsr = igsr.rename(columns={"Superpopulation code": "SuperpopulationCode"})
igsr


# In[4]:


#map sample name column to eigenvector 
sampleNamesWCode = eigVec.merge(igsr, left_on='SampleName', right_on='Sample name').reindex(columns=['SampleName','PC1','PC2','PC3','PC4','PC5','PC6','PC7','PC8', 'PC9','PC10','SuperpopulationCode'])
sampleNamesWCode.head()


# In[11]:


#get list of unique population codes
popCodes = igsr.SuperpopulationCode.unique()
populationCategories = np.delete(popCodes, [5])
list(populationCategories)


# In[23]:


#plot scatterplot of PC1 and PC2 grouped by SuperpopulationCode
seaborn.set(style='ticks')
fg = seaborn.scatterplot(data=sampleNamesWCode, x='PC1', y='PC2', hue='SuperpopulationCode', hue_order=list(populationCategories), legend='full')
plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)


# In[ ]:




