# Function: rename and assign

# Takes a data frame, determines whether it's user_platformaction.facts or user.dimensions,
# and assigns it the proper name in teh global environment

rename_and_assign <- function(df){
  if(ncol(df) == 4){
    df %>%
      rename(
        user_id = User.Dimensions.ID,
        account_created_date = Date.Dimensions.Platform.Action.Date,
        champion_id = User.Connected.to.Champion.Dimensions.ID,
        account_type = User.Dimensions.Account.Type
      ) %>%
      mutate(
        account_created_date = as.numeric(gsub("-", "", account_created_date))
      ) %>%
      assign("user.dimensions", ., envir = globalenv())
  } else if(ncol(df) == 2){
    assign("user_platformaction.facts", df, envir = globalenv())
  }
}