# function: get_short_version

get_short_version <-
  function(x){
    x %>%
      {gsub("_users", "", .)} %>%
      {gsub("count_distinct_", "", .)} %>%
      {gsub("percent_active", "percentactive", .)} %>%
      paste(collapse = "_")
  }