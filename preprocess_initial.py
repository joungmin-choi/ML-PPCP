import pandas as pd 
import numpy as np

dirname = "../WWTP_PPCP_dataset/"
wwtp = "USF"

for trip_num in range(1,5) : #5
	filename = dirname + wwtp + "_trip_" + str(trip_num) + ".csv"
	data = pd.read_csv(filename)
	data.rename(columns = {'Unnamed: 0' : 'PPCP'}, inplace = True)
	data.dropna(axis = 0, inplace = True)
	data.reset_index(inplace = True, drop = True)

	if trip_num == 1 :
		ppcp_list = data['PPCP'].tolist()
		treatment_stage_list = data.columns.tolist()
		treatment_stage_list.remove('PPCP')
		if wwtp == "HRSD" :
			treatment_stage_list.remove('HRSD3')
			treatment_stage_list.remove('HRSD10')
			treatment_stage_list.remove('HRSD11')
		else : 
			treatment_stage_list.remove('USF3')
			treatment_stage_list.remove('USF7')
			treatment_stage_list.remove('USF9')
			treatment_stage_list.remove('USF10')
		init_list = []
		for i in range(len(treatment_stage_list)-1) :
			init_list.append(0)
		rm_eff_dict = {}
		count_dict = {}
		for ppcp in ppcp_list :
			rm_eff_dict[ppcp] = init_list.copy()
			count_dict[ppcp] = init_list.copy()

	for i in range(len(data)) :
		for j in range(len(treatment_stage_list)-1) :
			tmp_stage_in = treatment_stage_list[j]
			tmp_stage_out = treatment_stage_list[j+1]

			if (trip_num == 4) and (tmp_stage_out == "HRSD6") :
				tmp_stage_out = "HRSD6A"
			elif (trip_num == 4) and (tmp_stage_in == "HRSD6") :
				tmp_stage_in = "HRSD6B"
			tmp_ppcp = data['PPCP'][i]
			#if data[tmp_stage_in][i] != 0 :
			if (data[treatment_stage_list[0]][i] != 0) and (data[tmp_stage_in][i] != 0) :
				#tmp_rm = (data[tmp_stage_in][i] - data[tmp_stage_out][i]) / data[tmp_stage_in][i] * 100
				tmp_rm = (data[tmp_stage_in][i] - data[tmp_stage_out][i]) / data[treatment_stage_list[0]][i] * 100
				if tmp_ppcp not in ppcp_list :
					rm_eff_dict[tmp_ppcp] = init_list.copy()
					count_dict[tmp_ppcp] = init_list.copy()
				rm_eff_dict[tmp_ppcp][j] += tmp_rm
				count_dict[tmp_ppcp][j] += 1
				#print(tmp_ppcp, tmp_stage_in, tmp_stage_out, tmp_rm, rm_eff_dict[tmp_ppcp][j])


count_df = pd.DataFrame(count_dict)
rm_eff_df = pd.DataFrame(rm_eff_dict)

rm_eff_avg_df = rm_eff_df.copy()

final_ppcp_list = rm_eff_df.columns.tolist()
for ppcp in final_ppcp_list :
	for i in range(len(rm_eff_df)) :
		if count_df[ppcp][i] != 0 :
			rm_eff_avg_df[ppcp][i] = rm_eff_avg_df[ppcp][i]/count_df[ppcp][i]
		else :
			rm_eff_avg_df[ppcp][i] = np.nan

'''
HRSD1 - HRSD2 : Primary Clarification
HRSD2 - HRSD4 : Activated Sludge
HRSD4 - HRSD5 : Coagulation-Sedimentation
HRSD5 - HRSD6 : Ozonation
HRSD6 - HRSD7 : BAF-GAC (BAF: Biologically Active Filtration, GAC: Granular Activated Carbon)
HRSD7 - HRSD8 : UV Disinfection
HRSD8 - HRSD9 : Chlorination

USF1 - USF2 : Primary Clarification
USF2 - USF4 : Activated Sludge
USF4 - USF5 : Denitrification Filters
USF5 - USF8 : Chlorination
'''

if wwtp == "HRSD" :
	rm_eff_avg_df.index = ['Primary Clarification', 'Activated Sludge', 'Coagulation-Sedimentation', 'Ozonation', 'BAF-GAC', 'UV Disinfection', 'Chlorination']
else :
	rm_eff_avg_df.index = ['Primary Clarification', 'Activated Sludge', 'Denitrification Filters', 'Chlorination']

rm_eff_avg_df = rm_eff_avg_df.T
rm_eff_avg_df.dropna(how = 'all', inplace = True)
rm_eff_avg_df.to_csv(wwtp + "_removal_efficency_initial.csv", mode = "w", index = True)

rm_eff_avg_df.dropna(inplace = True)
rm_eff_avg_df.to_csv(wwtp + "_removal_efficency_initial_without_NA.csv", mode = "w", index = True)





