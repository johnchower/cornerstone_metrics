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

