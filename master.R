# Master script.
# Run this to produce the report results

library(dplyr)
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

champion.facts <- read.csv("champion_facts_final.csv", stringsAsFactors = F)

calculate_WAU(stardate = 20160812, enddate = 20160818, filter_internals = T)


