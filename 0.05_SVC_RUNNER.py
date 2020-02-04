# python2.7
# version of "treeClassifier" script that will automatically remove previous outfiles
# and caluclate the metrics without needing a shell script

#------------------------------------------------------------------------------

import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn.utils import shuffle
from sklearn import metrics

from sklearn.metrics import accuracy_score
from sklearn.metrics import roc_auc_score
from sklearn.metrics import roc_curve
from sklearn.metrics import classification_report, confusion_matrix

#------------------------------------------------------------------------------

PREFIX = "TMP"

# data
target = pd.read_csv('target_n-100_npos-20_n-spike-20_n-genes-10010_n-core-10000_n-non-core-10000000_noise_0.05.csv', header=0, index_col=None)


data_tr = pd.read_csv('data_n-100_npos-20_n-spike-20_n-genes-10010_n-core-10000_n-non-core-10000000_noise_0.05.tr.csv', header=None, index_col=0)
#data_tr = pd.read_csv('small.csv', header=None, index_col=0)
data = data_tr.transpose()

# model
from sklearn import svm
from sklearn.svm import SVC

estimator = SVC(random_state=42, probability=True, kernel = 'linear')

#------------------------------------------------------------------------------

# fit model
estimator.fit(data, target.values.ravel())

#------------------------------------------------------------------------------

#feat_imp = pd.Series(estimator.coef_, data.columns).sort_values(ascending=False)
feat_imp = pd.Series(estimator.coef_[0].ravel(), data.columns).sort_values(ascending=False)
feat_imp.to_csv('0.05_feat_importances.csv', sep=',', header=None)

