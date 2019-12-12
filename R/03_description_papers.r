# Process data

library(here)
library(tidyverse)
library(kableExtra)

papers2010_2019 <- readRDS(file = here("data", "papers2010_2019.rda"))
data_av1 <- readRDS(file = here("data", "data_av1.rda"))

papers <- 
  papers2010_2019 %>% 
  inner_join(data_av1, by="id") %>%
  arrange(id)

n_papers <- nrow(papers)


## Distribution of studies: journal vs conference
papers %>%
  mutate(type = ifelse(type=="Book", "Artículo en conferencia", type),
         type = ifelse(type=="InProceedings", "Artículo en conferencia", type),
         type = ifelse(type=="Article", "Artículo en revista", type)) %>%
  group_by(type) %>% 
  summarise(n = n()) %>%
  mutate(proportion  = n / n_papers, 
         proportion_lbl = paste0(round(proportion*100,0), "%")) %>%
  select(`Tipo de documento` = type,
         `N` = n,
         `%`= proportion_lbl) %>%
  knitr::kable(format="html", escape = T, booktabs = TRUE) %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))

## Temporal distribution of studies 

# In case a year has no studies, add that year to the series. 
# Input parameter 'n': number of studies for a missed year
add_missing_years <- function(n) {
  years_papers <- unique(papers$year)
  years_gap <- setdiff(seq(2010,2020,by=1), years_papers)
  years_tibble <- tibble(year = integer(), n = integer())
  if (length(years_gap) > 0) {
    for (year in years_gap) {
      years_tibble <- add_row(years_tibble, year=year, n=n)
    }
  }
  return(years_tibble);
}


papers %>%
  group_by(year) %>% 
  summarise(n = n()) %>%
  bind_rows(add_missing_years(0)) %>%
  arrange(year) %>%
  ggplot(aes(x=year, y=n)) +
  geom_line(size=2, alpha=.4) +
  labs(title="Distribución temporal de los estudios", 
    x="Año", 
    y="# de estudios", 
    caption="Fuente: autores") +
  scale_y_continuous(breaks=seq(0,10,by=1)) +
  scale_x_continuous(breaks=seq(2010,2020,by=1)) +
  theme_minimal() +
  theme(panel.grid.minor = element_blank()) +
  theme(panel.background = element_blank())

ggsave(here("figs", "fig02.png"))


## Temporal distribution of studies according to av_status
papers %>%
  group_by(av_status) %>% 
  summarise(n = n()) %>%
  mutate(proportion  = n / n_papers, 
         proportion_lbl = paste0(round(proportion*100,0), "%")) %>%
  arrange(n) %>%
  select(`Estado de desarrollo AV` = av_status,
         `N` = n,
         `%`= proportion_lbl) %>%
  knitr::kable(format="html", escape = T, booktabs = TRUE) %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))

papers %>%
  group_by(year, av_status) %>% 
  summarise(n = n()) %>%
  mutate(total_year = sum(n),
         proportion_year = n/total_year,
         proportion_year_lbl = paste0(round(proportion_year*100,0), "%")) %>%
  ggplot(aes(x=year, y=n, fill=av_status)) + 
  geom_bar(stat="identity") +
  geom_text(aes(label=proportion_year_lbl), size=2.7, position=position_stack(vjust = 0.5)) +
  # stat_summary(fun.y = sum, aes(label=..y.., group=year), geom = "text", vjust=-.2) +
  labs(title="Distribución temporal de los estudios \ncoloreados por 'av_status'",
    x="", 
    y="# de estudios") +
  scale_y_continuous(breaks=seq(0,10,by=1)) +
  scale_x_continuous(breaks = seq(2010,2020, by=1)) +
  guides(fill=guide_legend(title="Estado desarrollo", nrow=4)) + # modify legend title
  theme_minimal() + 
  theme(panel.grid.minor = element_blank()) +
  theme(panel.background = element_blank()) +
  theme(legend.title = element_text(size=9),
        legend.position = "bottom")

ggsave(here("figs", "fig03.png"))

## application vs arch vs year

papers %>%
  arrange(desc(year)) %>%
  select(ID = id,
        `Año` = year,
        `Aplicación` = av_application,
        `Arquitectura` = av_arch) %>%
  knitr::kable(format="html", escape = T, booktabs = TRUE) %>%
  kable_styling(bootstrap_options = c("striped", "hover", "condensed", "responsive"))


# scatterplot
library(ggrepel)
papers %>%
  select(year, av_arch, av_status) %>%
  group_by(year, av_arch, av_status) %>%
  summarise(n = n()) %>%
  ggplot(aes(x=year, y=av_arch, color=av_status)) +
  geom_point(aes(size=n*4),  alpha=.5, na.rm = TRUE) +
  geom_label_repel(aes(label=n, color=av_status), size=2.5, na.rm = TRUE) +
  scale_x_continuous(breaks = seq(2010,2020, by=1)) +
  scale_size_area(max_size=12) +
  labs(title="Distribución temporal de los estudios \nsegún la aproximación técnica",
       x="Año", 
       y="Aproximación técnica") +
  # Which legend to show
  guides(color="legend",size = "none") +
  # guides(color=guide_legend(title="Estado desarrollo", nrow=4))+ 
  theme_minimal() + 
  theme(panel.grid.minor = element_blank()) +
  theme(panel.background = element_blank()) +
  theme(legend.title = element_text(size=9),
        legend.position = "bottom")

ggsave(here("figs", "fig04.png"), width = 16, units = "cm")

# 
# library(DT)
# 
# # Table output with DT
# papers %>%
#   arrange(desc(year)) %>%
#   select(ID = id,
#          `Año` = year,
#          `Aplicación` = av_application,
#          `Arquitectura` = av_arch) %>%
#     datatable(rownames = FALSE,
#             filter = "top",
#             class = "table-bordered table-condensed hover",
#             extensions = c("Buttons"),
#             options = list(
#                pageLength = 5, #autoWidth = TRUE,
#                dom = 'Blfrtip',  # https://datatables.net/reference/option/dom
#                buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
#             ))  
