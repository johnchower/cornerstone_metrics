# Function: load_data

# Gets data from the source and loads it into memory.

load_data <- function(
  data.loc = paste(find_root("README.md"), "looker_csvs", sep = "/")
){
  data.loc %>%
    paste(., dir(.), sep = "/") %>%
    as.list %>%
    lapply(FUN = read.csv)
}