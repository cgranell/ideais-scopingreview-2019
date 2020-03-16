# ideais-scopingreview-2019
Code and data of the scoping review on virtual assistant and geographic information in the context of the IDEAIS project.

## Folder description 

The folder `data-raw` contains two raw data sets: 
* bibtext file
* MS Excel file 

The folder `data` contains processed data sets that are the input for the analysis. 

The folder `figs` contains the figures generated by the scripts.

The folder `R` contains the scripts used in the data preparation and analysis.
* `01_download_bibfile.r`: Download a remote bibtex file into the `data-raw` folder and process it into a dataframe called `papers2010_2019` that's saved in the folder `data`.
* `02_download_datafile.r`: Download a remote excel file used as data extraction form into the `data-raw` folder and process it into three different files for subsequent analysis: `data_av1`, `data_av2` and `data_geo`, which are all saved in the `data` folder. The first two files store variables associated to virtual assistants, the third one contains variables related to the support of geospatial informmation/analysis.  
* `03_description_papers.rmd`: Based on the `papers2010_2019` dataset, this script creates figures 2, 3 and 4 of the submitted paper. 
* `04_description_av.rmd`: Based on the `data_av1`, `data_av2` and `data_geo`dataset, this script creates figure 5 of the submitted paper. 
