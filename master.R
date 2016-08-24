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

run_date <- as.Date("2016-08-26")
weeks_to_measure <- c(1,2,4)
remove_internal_users <- F
save_location <- "~/Desktop"
save_name <- 
  paste(
    "WAU_metrics"
    , ifelse(remove_internal_users, "without_internal", "with_internal")
    , run_date
    , "weeks"
    , paste(weeks_to_measure, collapse = "")
    , sep = "_"
  )
view_results <- T

project_data_list <- load_data()

project_data_list %>%
  lapply(
    FUN = rename_and_assign
  )

rm(project_data_list)

source('one_off_create_champion_facts.r')
champion.facts <- read.csv("champion_facts_final.csv", stringsAsFactors = F) %>%
  rename(champion_group = Label)

week_definitions <- calculate_back_weeks(rundate = run_date, weeks_to_calc = weeks_to_measure) 

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
  dcast(
    champion_group ~ id + variable, value.var = "value"
  ) %>%
  arrange(
    champion_group == "Other",
    champion_group == "Internal Champion",
    champion_group
  )

output %>%
  write.csv(file = paste0(save_location, "/", save_name, ".csv"), row.names = F)

if(view_results){
  paste0(
    "open ",
    save_location, 
    "/",
    save_name,
    ".csv"
  ) %>% 
  system  
}


