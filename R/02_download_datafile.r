# Tidy extract variables of the reviewed papers 

# install.packages(c("here", "tidyverse", "googledrive", "readxl"))
library(here)
library(tidyverse)
library(googledrive)
library(readxl)

# Extract relevent data items regarding technical features from the shared folder in GDrive:
# - All column headings are copied to the third row, so we skip the firt two rows when reading the file
data_file_name <- "IDEAIS_4.5-6_fase3-extracciondatos"
gdata_url <- "https://drive.google.com/open?id=1fWTRpM1fkVMnDFiVrwtIbjuuzYQ3yh5a"
gdata_path <- drive_get(as_id(gdata_url))

gdata_file <- drive_ls(path = gdata_path$name, pattern = data_file_name, type = "spreadsheet")

data_path <- here::here("data-raw", gdata_file$name) # local file
# export Google Sheets to the default type: an Excel workbook
drive_download(file = as_id(gdata_file$id), path = data_path, overwrite = TRUE, verbose = TRUE)
drive_deauth()

data_path <- paste0(data_path, ".xlsx")
data_raw <- read_excel(data_path, skip = 1, na = c("NA",""))


# To lower case and remove white spaces of column names
colnames(data_raw) <- stringr::str_to_lower(colnames(data_raw))
colnames(data_raw) <- stringr::str_replace_all(colnames(data_raw), "[\\s]", "")

# Convert id from "1" to "001"
data_raw$id <- stringr::str_pad(data_raw$id, 3, pad = "0")

# Select the most relevant colums now, drop the others
sel_cols <- c("id", 
              "av_aplicacion", "av_estado", "av_nombre", "av_lugar", "av_plataforma", "av_areas_investigacion",
              "geo_propósito", "geo_fuentes", "geo_tecnología", "geo_entrada", "geo_salida", "geo_estándares", 
              "geo_procesamiento", "geo_procesamiento_tipo", "procesamientonogeo",
              "notas")

# av_: groups variables related to 'virtual assisstats'
# geo__: groups variables related to use of geo


dataitems2010_2019 <-
  data_raw  %>%
  select(sel_cols) %>%
  rename(id = id,
         av_application = av_aplicacion,
         av_status = av_estado,
         av_name = av_nombre,
         av_place = av_lugar,
         av_platform = av_plataforma,
         av_researchareas = av_areas_investigacion,
         geo_goal = `geo_propósito`,
         geo_sources = geo_fuentes,
         geo_tech = `geo_tecnología`,
         geo_inputmode = geo_entrada,
         geo_outputmode = geo_salida,
         geo_standards = `geo_estándares`,
         geo_process = geo_procesamiento,
         geo_processtype = geo_procesamiento_tipo,
         other_process = procesamientonogeo,
         notes = notas)

#TODO: clean variables


data_path <- here::here("data", "dataitems2009_2019.csv")
write_csv(dataitems2010_2019, data_path)
data_path <- here::here("data", "dataitems2009_2019.rda")
saveRDS(dataitems2010_2019, data_path)
