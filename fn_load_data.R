# Function: load_data

# Gets data from the source and loads it into memory.

load_data <- function(
  data.loc = paste(getwd(), "input_csvs", sep = "/")
){
  data.loc %>%
    dir %>%
    as.list %>%
    lapply(FUN = read.csv)
}