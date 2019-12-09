# Downloads and transform a bibtext file into a tidy dataset

#install.packages(c("here", "RefManageR", "tidyverse", "googledrive"))
library(here)
library(RefManageR)
library(tidyverse)
library(googledrive)

# Retrieve bibtext file from the shared folder 'Documentos' in GDrive
bib_file_name <- "IDEAIS_4.5-6_scopus-N=30.bib"
gdata_url <- "https://drive.google.com/open?id=1fWTRpM1fkVMnDFiVrwtIbjuuzYQ3yh5a"
gdata_path <- drive_get(as_id(gdata_url))

gdata_file <- drive_ls(path = gdata_path$name, pattern = bib_file_name)

data_path <- here::here("data-raw", gdata_file$name) # local file
drive_download(file = as_id(gdata_file$id), path = data_path, overwrite = TRUE, verbose = TRUE)
drive_deauth()


papers_raw <- RefManageR::ReadBib(data_path, check = "warn", .Encoding = "UTF-8") %>%
  as.data.frame() %>% as_tibble()

# for the time being, turn rownames into a column
papers_raw <- rownames_to_column(papers_raw, "bibtextId")

# Get rid of vars I will not use, rename vars I keep.
# Get rid of curly brackets and extra quotation marks in titles
# NOTE: Bibtex field 'notes' is the filename of the paper.
papers2010_2019 <-
  papers_raw %>%
  select(type = bibtype, title, abstract, year, keywords, filename=notes) %>%
  mutate(id = stringr::str_sub(filename, 1, 3),
         year = as.integer(year),
         title = stringr::str_replace_all(title, "[\"|{|}]", "")) %>%
  arrange(year)


data_path <- here::here("data", "papers2010_2019.csv")
write_csv(papers2010_2019, data_path)
data_path <- here::here("data", "papers2010_2019.rda")
saveRDS(papers2010_2019, data_path)

