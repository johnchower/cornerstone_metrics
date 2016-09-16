# Master script.
# Run this to produce the report results

library(dplyr)
library(magrittr)
library(rprojroot)
library(reshape2)

source('fn_calculate_WAU.r')
source('fn_load_data.r')
source('fn_rename_and_assign.r')
source('fn_calculate_back_weeks.r')
source('fn_get_short_version.r')

# Parameters ####

run_date <- as.Date("2016-09-16")

weeks_to_measure <- c(1,2,4,6) 
week_definitions <- calculate_back_weeks(rundate = run_date, weeks_to_calc = weeks_to_measure) 

metrics_to_track <- 
  c(
    "count_distinct_core_users"
     ,
     "count_distinct_active_users"
     ,
     "percent_active_users"
     ,
     "count_distinct_existing_users"
  )

remove_internal_users <- F

input_data_location <- paste(find_root("README.md"), "looker_csvs", sep = "/")

save_location <- "/Users/johnhower/Google Drive/Analytics_graphs/Cornerstone_Metrics/2016_09_16"

save_name <- 
  paste(
    "cornerstone_metrics"
    , get_short_version(metrics_to_track)
    , ifelse(remove_internal_users, "without_internal", "with_internal")
    , run_date
    , "weeks"
    , paste(weeks_to_measure, collapse = "")
    , sep = "_"
  )

view_results <- T # If T, then the output csv will open automatically upon completion.

# Calculation ####

project_data_list <- load_data(data.loc = input_data_location)

project_data_list %>%
  lapply(
    FUN = rename_and_assign
  )

rm(project_data_list)

source('create_champion_facts_table.r')
champion.facts <- read.csv("champion_facts_final.csv", stringsAsFactors = F) %>%
  rename(champion_group = Label)

# Run calculations by champion group
output <- week_definitions %>%
  group_by(week, start_date, end_date) %>%
  do(
    {
      calculate_WAU(.$start_date, .$end_date, remove_internal_users)
    }
  ) %>% 
  ungroup %>% 
  mutate(id = paste(week, start_date, end_date, sep = "_")) %>%
  select(-week, -start_date, -end_date, -count_distinct_existing_users) %>% 
  melt(
    id.vars = c("id", "champion_group")
  ) %>% 
  filter(variable %in% metrics_to_track) %>%
  mutate(value = round(value, 3)) %>%
  dcast(
    champion_group ~ variable + id, value.var = "value"
  ) %>%
  arrange(
    champion_group == "all",
    champion_group == "Other",
    champion_group == "Internal Champion",
    champion_group
  )

write.csv(output,
          file = paste0(save_location,
                          "/", save_name, ".csv"),
          row.names = F)

if(view_results){
  paste0(
    "open ",
    gsub(" ", "\\\\ ", save_location), 
    "/",
    save_name,
    ".csv"
  ) %>% 
  system  
}


