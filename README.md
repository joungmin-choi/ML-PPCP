# A Machine Learning Framework to Predict PPCP Removal Through Various Water Reuse Treatment Processes
This is a source code for analysis in "A Machine Learning Framework to Predict PPCP Removal Through Various Water Reuse Treatment Processes" paper.

## Requirements
* python (>= 3.11.3)
* scikit-learn (>= 1.2.2)
* pandas (>= 2.0.2)
* numpy (>= 1.24.3)
* kmodes (>= 0.12.2)
* R (= v4.1.2)

### Installation
To install the above requirments, please run below commands in the terminal :
```
pip install numpy pandas os sys kmodes
pip install -U scikit-learn
```

## Usage
Clone the repository or download source code files.

## Python scripts for C1 and C2 approach and classification of PPCPs using Abraham descriptors and log Kow
1. C1: Clustering based on the most efficient individual process relative to treatment train influent
2. C2 : Clustering based on the removal pattern of PPCP in a given process relative to the immediately upstream process
  
* calculate_URE.py : calculate the Unit Removal Efficiency (URE) for each PPCP
* calculate_RE.py : calculate the removal efficiency of each treatment process for each PPCP
* run_C1_C2_ML.py : Perform C1 and C2 clustering, respectively and classify PPCPs using Abraham descriptors and log Kow

## R scripts for the validation and plot analysis results
* KW_analysis_chemical_properties.R : Analysis of the distinct chemical properties across PPCP clusters based on the statistics using Kruskal-Wallis test
* plot_analysis_results.R : codes to plot the analysis and validation results

## Contact
If you have any questions or problems, please contact to joungmin AT vt.edu.
