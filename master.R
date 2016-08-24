# Master script.
# Run this to produce the report results

library(dplyr)
library(magrittr)
library(rprojroot)

source('fn_calculate_WAU.r')
source('fn_load_data.r')
source('fn_rename_and_assign.r')

project_data_list <- load_data()

project_data_list %>%
  lapply(
    FUN = rename_and_assign
  )

rm(project_data_list)

source('one_off_create_champion_facts.r')
champion.facts <- read.csv("champion_facts_final.csv", stringsAsFactors = F) %>%
  rename(champion_group = Label)




