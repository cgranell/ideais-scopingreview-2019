# A scoping review on the use, processing, and fusion of geographic data in virtual assistants

Data and code script files for the paper __"A scoping review on the use, processing, and fusion of geographic data in virtual assistants"__, in response to the TGIS' special issue on [Cyberinfrastructure and Intelligent Spatial Decision Support Systems](https://onlinelibrary.wiley.com/pb-assets/assets/14679671/CfP-%20Special%20Issue%20CyberInfrastructure-1573213752420.pdf)

> Carlos Granell, Paola G. Pesántez-Cabrera, Luis M. Vilches-Blázquez, Rosario Achig, Miguel R. Luaces, Alejandro Cortiñas-Álvarez, Carolina Chayle, Villie Morocho-Zurita. 
> A scoping review on the use, processing, and fusion of geographic data in virtual assistants. 
> Submitted to Transactions in GIS.
> DOI: 


This repository is archived on Zenodo:

<!--
[![DOI](https://www.zenodo.org/badge/DOI/10.5281/zenodo.3901461.svg)](https://doi.org/10.5281/zenodo.3901461)
-->

Complementing the published article and this repo, the results of the analysis are made available as HTML pages, [here](https://rpubs.com/cgranell/reviewtgis01) and [here](https://rpubs.com/cgranell/reviewtgis02). 


_This work has been partially supported by the CYTED program under the grant number 519RT0579 ["IDEAIS network" - Asistentes Inteligentes para las Infraestructuras de Datos Espaciales.](http://www.redideais.net/)_


## Reproduce Online

Click the "Binder" button below to open the repo on [binder.org](https://mybinder.org/).

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/cgranell/ideais-scopingreview-2019/master?urlpath=rstudio)


The reproduction of the published results depends on two script files: `R\03_description_paper.rmd` and `R\04_description_av.rmd`.

In the RStudio page, open the fist file `R\03_description_paper.rmd`, and then select "Knit > Knit to HTML" to render the results of the analysis, which will be automatically displayed in a browser pane. Alternatively, click on the file `03_description_papers.html` and select "View in Web Browser" to display it.  

In the RStudio page, open the second file `R\04_description_av.rmd`, and then select "Knit > Knit to HTML" to render the results of the analysis, which will be automatically displayed in a browser pane. Alternatively, click on the file `03_description_papers.html` and select "View in Web Browser" to display it.  

In case you want to run the other script files (`R/01_download.bibfile.r` and` R/02_download_datafile.r`), which is not strictly necessary since these scripts convert raw data to input data for later analysis, disable commented packages in `install .r` and install them.

## Reproduce locally

Open the two main analysis files (`R\03_description_paper.rmd` and `R\04_description_av.rmd`) with RStudio. Then selecl "Knit > Knit to HTML" to render the resutls of the analyses as HTML pages. If you have errors, try running block-by-block to locate the problem.

The R script does not include code to install the required packages. Run `install.R` to install all dependencies in your local machine.

## Files in this repository  

The folder `data-raw` contains two raw data sets: 
* bibtext file, which contains bblioteca data fo the eligible papers
* MS Excel file, which contains data extracted from the eligibile papers. The list of extracted variables are explained in the manuscript (Section 2).

The folder `data` contains processed data sets that are the input for the analysis.

* `papers2010_2019` file (in csv and rda formats): Bibliographic data in tidy form of the eligible papers. 
* `data_av1.rda` file: Extracted variables data in tidy form related to the characteristics of the virtual assistants of the eligible papers.
* `data_av2.rda` file: Extracted variables data in tidy form related to the characteristics of the virtual assistants of the eligible papers.
* `data_geo.rda` file: Extracted variables data in tidy form related to the use of geographic information by the virtual assistants of the eligible papers.
* `data_sankey.csv`: Input data to generate the parallel set plot (Figure 4). 

The folder `figs` contains the figures generated by the scripts.

* `fig01.png`: Flowchart of the eligibility process according to the PRISMA methodology. It is not created by code 
* `fig02.png`: Temporal distribution of eligible papers. Note that the article in 2020 was presented in 2019, but the publication date (publisher) is 2020. The dashed line denotes the sum of journal papers and conference papers per year. 
* `fig03_clound_wordstems_abstract.png`: Left side of the figure  hows a word cloud of the most frequent word stems (minimum 5 occurrences) in all abstracts after removing stopwords. Right side of the figure shows a frequency bar chart of the top 15 word stems. 
* `fig04_parallelsets.png`: It shows the interaction between group, application domain/feature, and geospatial usage of the virtual assistants.
* `fig05-bubbles_facet.png`. Temporal distribution of the virtual assistants according to their technical approach and development status.
* `fig06.png`: Barchart showing percentages of the research areas identified in the reviewed papers.


The folder `R` contains the scripts used in the data preparation and analysis.
* `01_download_bibfile.r`: Download a remote bibtex file into the `data-raw` folder and process it into a dataframe called `papers2010_2019` that's saved in the folder `data`. _Note: It is not necessary to run this script for reproduction. The output data is already up to date._ 
* `02_download_datafile.r`: Download a remote excel file used as a data extraction form into the `data-raw` folder and process it into three different files for subsequent analysis: `data_av1`, `data_av2` and `data_geo`, which are all saved in the `data` folder. The first two files store variables associated to virtual assistants, the third one contains variables related to the support of geospatial information/analysis. _Note: It is not necessary to run this script for reproduction. The output data is already up to date._  
* `03_description_papers.rmd`: Based on the `papers2010_2019` dataset, this script creates figures 2 and 4 of the submitted paper. _Note: Runing this script is required for reproduction._ 
* `04_description_av.rmd`: Based on the `sankey` data, this script generates the figure 4. Based on the `data_av1`, `data_av2` and `data_geo`datasets, this script also creates figures 5 and 6 of the paper. _Note: Runing this script is required for reproduction._ 

## License

The documents in this repository are licensed under a [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/).

All contained code is licensed under the [Apache License 2.0](https://choosealicense.com/licenses/apache-2.0/).

The data used is licensed under a [Open Data Commons Attribution License](https://opendatacommons.org/licenses/by/).
