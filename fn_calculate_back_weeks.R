# Function: calculate_back_weeks

calculate_back_weeks <- 
  function(
    rundate = Sys.Date(),
    weeks_to_calc = c(1,2,4)
  ){
    startdates <- (rundate - weeks_to_calc*7) 
    enddates <- (startdates + 6)
    
    startdates %<>%
      as.character %>%
      {gsub("-", "", .)} %>%
      as.numeric
    
     enddates %<>%
      as.character %>%
      {gsub("-", "", .)} %>%
      as.numeric
    
    data.frame(
      week = weeks_to_calc,
      start_date = startdates,
      end_date = enddates
    )
  }