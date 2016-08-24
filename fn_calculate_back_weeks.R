# Function: calculate_back_weeks

calculate_back_weeks <- 
  function(
    rundate = Sys.Date()
    , weeks_to_calc = c(1,2,4)
  ){
    startdates <- rundate - weeks_to_calc*7
    enddate <- startdates + 6
    data.frame(
      week = weeks_to_calc,
      startdate = startdates,
      enddate = enddates
    )
  }