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
drive_download(file = as_id(gdata_file$id), path = data_path, overwrite = TRUE, verbose = TRUE, type = "xlsx")
drive_deauth()

# As  Google Sheets are exported by default as an Excel workbook, add file extension to the path
data_path <- paste0(data_path, ".xlsx")
data_raw <- read_excel(data_path, skip = 1, na = c("NA",""))


# To lower case and remove white spaces of column names
colnames(data_raw) <- stringr::str_to_lower(colnames(data_raw))
colnames(data_raw) <- stringr::str_replace_all(colnames(data_raw), "[\\s]", "")

# Convert id from "1" to "001"
data_raw$id <- stringr::str_pad(data_raw$id, 3, pad = "0")

# Select the most relevant colums now, drop the others
sel_cols <- c("id", 
              "av_aplicacion_norm",
              "av_aplicacion", 
              "av_estado", 
              "av_nombre", 
              "av_lugar", 
              "av_arquitectura", 
              "av_plataforma", 
              "av_areas_investigacion",
              "geo_propósito_norm", 
              "geo_propósito", 
              "geo_fuentes", 
              "geo_tecnología", 
              "geo_entrada", 
              "geo_salida", 
              "geo_estándares", 
              "geo_procesamiento", 
              "geo_procesamiento_tipo", 
              "procesamientonogeo",
              "notas")

# av_: groups variables related to 'virtual assisstats'
# geo_: groups variables related to use of geo
dataitems2010_2019 <-
  data_raw  %>%
  select(sel_cols) %>%
  rename(id = id,
         av_app_norm = av_aplicacion_norm,
         av_application = av_aplicacion,
         av_status = av_estado,
         av_name = av_nombre,
         av_place = av_lugar,
         av_arch = av_arquitectura,
         av_platform = av_plataforma,
         av_researchareas = av_areas_investigacion,
         geo_goal_norm = `geo_propósito_norm`,
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



# Tidy up "av" variables
data_av1 <- 
  dataitems2010_2019 %>%
  select(id, av_name, av_place, av_app_norm, av_application, av_status, av_arch, av_platform)

sel_cols_av <- c("av_application", "av_status", "av_arch", "av_platform")
data_av1[sel_cols_av] <- lapply(data_av1[sel_cols_av], FUN = function(x) stringr::str_to_sentence(x))
data_av1$av_status <- factor(data_av1$av_status) 
data_av1$av_arch <- factor(data_av1$av_arch)
data_av1$av_app_norm <- factor(data_av1$av_app_norm)

data_av2 <- 
  dataitems2010_2019 %>%
  select(id, av_researchareas)

data_av2 <- separate_rows(data_av2, av_researchareas, sep="AND")
data_av2$av_researchareas <- stringr::str_trim(data_av2$av_researchareas)
data_av2$av_researchareas <- stringr::str_to_sentence(data_av2$av_researchareas)
data_av2$av_researchareas <- factor(data_av2$av_researchareas)


# Tidy up "geo" variables
data_geo <- 
  dataitems2010_2019 %>%
  select(id, starts_with("geo"))

sel_cols_geo <- colnames(data_geo)
data_geo[sel_cols_geo] <- lapply(data_geo[sel_cols_geo], FUN = function(x) stringr::str_trim(x))

sel_cols_geo <- c("geo_inputmode", "geo_outputmode", "geo_standards", "geo_process")
data_geo[sel_cols_geo] <- lapply(data_geo[sel_cols_geo], FUN = function(x) stringr::str_to_upper(x))

data_geo$geo_standards <- factor(data_geo$geo_standards)
data_geo$geo_process <- factor(stringr::str_to_upper(data_geo$geo_process))
data_geo$geo_goal_norm <- factor(data_geo$geo_goal_norm)


# data_path <- here::here("data", "data_av1.csv")
# write_csv(data_av1, data_path)
data_path <- here::here("data", "data_av1.rda")
saveRDS(data_av1, data_path)
# data_path <- here::here("data", "data_av2.csv")
# write_csv(data_av2, data_path)
data_path <- here::here("data", "data_av2.rda")
saveRDS(data_av2, data_path)
# data_path <- here::here("data", "data_geo.csv")
# write_csv(data_geo, data_path)
data_path <- here::here("data", "data_geo.rda")
saveRDS(data_geo, data_path)
