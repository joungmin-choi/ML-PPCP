import pandas as pd 
import os
from sklearn.model_selection import KFold
from sklearn import svm, linear_model
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score
from sklearn.metrics import f1_score

###################################################
####### C1 approach and ML clssification ##########
###################################################

resDir = "./results_first_app/"
try :
	os.mkdir(resDir)
except :
	print("Exist!")

wwtp_name = 'USF'
filename = "./dataset/" + wwtp_name + "_removal_efficency_initial.csv"

data = pd.read_csv(filename, index_col = 0) 
data.dropna(subset=['Primary Clarification'], inplace = True)

stage_list = data.columns.tolist()
data.reset_index(inplace = True)
data.rename(columns = {'index' : 'PPCP'}, inplace = True)

cluster_list = []
cluster_num_list = []

for i in range(len(data)) : #len(data)
	tmp_abun = -1000.0
	tmp_stage = ''
	for stage in stage_list :
		if data[stage][i] > tmp_abun :
			tmp_abun = data[stage][i]
			tmp_stage = stage
	cluster_list.append(tmp_stage)
	cluster_num_list.append(stage_list.index(tmp_stage))

data["cluster"] = cluster_list
data["cluster_num"] = cluster_num_list
data.to_csv(resDir + wwtp_name + "_results.csv", mode = "w", index = False)
data[['PPCP', 'cluster', 'cluster_num']].to_csv(resDir + wwtp_name + "_cluster_label.csv", mode = "w", index = False)

data = pd.read_csv(resDir + wwtp_name + "_cluster_label.csv", index_col = 0)
abraham_data = pd.read_csv('./dataset/Abraham_Descriptors_with_logKOW.csv', index_col = 0)


tmp = scaler.fit_transform(abraham_data)
tmp = pd.DataFrame(tmp)
tmp.columns = abraham_data.columns
tmp.index = abraham_data.index

abraham_data = tmp

X = pd.merge(data, abraham_data, left_index = True, right_index = True)
del X['cluster']

X.groupby('cluster_num').count()

y = X['cluster_num'].values
del X['cluster_num']

X.reset_index(inplace = True, drop = True)

kf = KFold(n_splits=5, shuffle = True, random_state = 42)
svm_acc_list = []
rf_acc_list = []
lr_acc_list = []

svm_f1_list = []
rf_f1_list = []
lr_f1_list = []

i = 1
for train_index, test_index in kf.split(X):
	X_train, X_test = X.loc[train_index], X.loc[test_index]
	y_train, y_test = y[train_index], y[test_index]
	svm_classifier = svm.SVC(kernel = 'rbf', probability=True, random_state=42) #, random_state=0
	svm_classifier = svm_classifier.fit(X_train, y_train)
	svm_predicted_class = svm_classifier.predict(X_test)
	tmp_acc = accuracy_score(y_test, svm_predicted_class)
	tmp_f1 = f1_score(y_test, svm_predicted_class, average = 'weighted')
	svm_acc_list.append(tmp_acc)
	svm_f1_list.append(tmp_f1)
	rf_classifier = RandomForestClassifier(random_state=42)
	rf_classifier = rf_classifier.fit(X_train, y_train)
	rf_predicted_class = rf_classifier.predict(X_test)
	tmp_acc = accuracy_score(y_test, rf_predicted_class)
	tmp_f1 = f1_score(y_test, rf_predicted_class, average = 'weighted')
	rf_acc_list.append(tmp_acc)
	rf_f1_list.append(tmp_f1)
	lr_classifier = LogisticRegression(random_state=42)
	lr_classifier = lr_classifier.fit(X_train, y_train)
	lr_predicted_class = lr_classifier.predict(X_test)
	tmp_acc = accuracy_score(y_test, lr_predicted_class)
	tmp_f1 = f1_score(y_test, lr_predicted_class, average = 'weighted')
	lr_acc_list.append(tmp_acc)
	lr_f1_list.append(tmp_f1)
	i = i + 1

acc_res = pd.DataFrame({'SVM' : svm_acc_list, 'RF' : rf_acc_list, 'LR' : lr_acc_list})
acc_res.loc['avg'] = acc_res.mean()

f1_res = pd.DataFrame({'SVM' : svm_f1_list, 'RF' : rf_f1_list, 'LR' : lr_f1_list})
f1_res.loc['avg'] = f1_res.mean()


resFileName = resDir + wwtp_name + "_f1_results_all.csv"
#resFileName = resDir + wwtp_name + "_acc_results_rm_4.csv"

#acc_res.to_csv(resFileName, mode = "w", index = True)
f1_res.to_csv(resFileName, mode = "w", index = True)


##################################################
####### C2 approach and ML clssification #########
##################################################
import pandas as pd 
import os
from sklearn.cluster import KMeans
from kmodes.kmodes import KModes

resDir = "./results_second_app/"
try :
	os.mkdir(resDir)
except :
	print("Exist!")

wwtp_name = 'HRSD'
filename = "./dataset/" + wwtp_name + "_removal_efficency.csv"

data = pd.read_csv(filename, index_col = 0) 
data.dropna(subset=['Primary Clarification'], inplace = True)


data.fillna(0.0, inplace = True)
stage_list = data.columns.tolist()
pattern_list = []
for i in range(len(stage_list)) :
	pattern_list.append([])

for i in range(len(data)) :
	for j in range(len(stage_list)) :
		if j == 0 :
			control = data[stage_list[j]][i]
		else :
			tmp_value = data[stage_list[j]][i]
			if tmp_value == 0 :
				pattern_list[j].append("B.D.") #B.D.
				control = tmp_value
				continue
			diff = tmp_value - control
			if control == 0 :
				diff_var = 100
			else :
				diff_var = diff/control * 100
			if diff_var < 0 :
				diff_var = diff_var * -1
			#
			if diff_var <= 10 :
				pattern_list[j].append("same")
			else :
				if diff > 0 :
					pattern_list[j].append("up")
				else :
					pattern_list[j].append("down")				
			control = tmp_value


ppcp_list = data.index.tolist()
tmp_dict = {}
tmp_dict["PPCP"] = ppcp_list
for i in range(1, len(stage_list)) :
	tmp_dict[stage_list[i]] = pattern_list[i]

num_cluster = 2
pattern_df = pd.DataFrame(tmp_dict)
pattern_df.set_index('PPCP', inplace = True, drop = True)

km = KModes(n_clusters=num_cluster, verbose=1,init='Huang', n_init = 4)
clusters = km.fit_predict(pattern_df)
pattern_df["cluster"] = clusters 
pattern_df.to_csv(resDir + wwtp_name + "_pattern_K_" + str(num_cluster) + ".csv", mode = "w", index = True)

pattern_df.groupby('cluster').count().to_csv(resDir + wwtp_name + "_pattern_K_" + str(num_cluster) + "_count_info.csv", mode = "w", index = True)


num_cluster = 2
data = pd.read_csv(resDir + wwtp_name + "_pattern_K_" + str(num_cluster) + ".csv", index_col = 0)
data = pd.DataFrame(data['cluster'])
abraham_data = pd.read_csv('./dataset/Abraham_Descriptors_with_logKOW.csv', index_col = 0)

###
tmp = scaler.fit_transform(abraham_data)
tmp = pd.DataFrame(tmp)
tmp.columns = abraham_data.columns
tmp.index = abraham_data.index

abraham_data = tmp
###


X = pd.merge(data, abraham_data, left_index = True, right_index = True)
y = X['cluster'].values
del X['cluster']
X.reset_index(inplace = True, drop = True)

kf = KFold(n_splits=5, shuffle = True, random_state = 42)
svm_acc_list = []
rf_acc_list = []
lr_acc_list = []
i = 1

for train_index, test_index in kf.split(X):
	X_train, X_test = X.loc[train_index], X.loc[test_index]
	y_train, y_test = y[train_index], y[test_index]
	svm_classifier = svm.SVC(kernel = 'rbf', probability=True, random_state=42) #, random_state=0
	svm_classifier = svm_classifier.fit(X_train, y_train)
	svm_predicted_class = svm_classifier.predict(X_test)
	tmp_acc = accuracy_score(y_test, svm_predicted_class)
	svm_acc_list.append(tmp_acc)
	rf_classifier = RandomForestClassifier(random_state=42)
	rf_classifier = rf_classifier.fit(X_train, y_train)
	rf_predicted_class = rf_classifier.predict(X_test)
	tmp_acc = accuracy_score(y_test, rf_predicted_class)
	rf_acc_list.append(tmp_acc)
	lr_classifier = LogisticRegression(random_state=42)
	lr_classifier = lr_classifier.fit(X_train, y_train)
	lr_predicted_class = lr_classifier.predict(X_test)
	tmp_acc = accuracy_score(y_test, lr_predicted_class)
	lr_acc_list.append(tmp_acc)
	i = i + 1

acc_res = pd.DataFrame({'SVM' : svm_acc_list, 'RF' : rf_acc_list, 'LR' : lr_acc_list})
acc_res.loc['avg'] = acc_res.mean()

resFileName = resDir + wwtp_name + "_acc_results_K_" + str(num_cluster) + ".csv"
acc_res.to_csv(resFileName, mode = "w", index = True)