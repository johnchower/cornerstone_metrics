# Function: calculate_WAU

# Given a date range (startdate, enddate), calculates, for each champion_group,
#	How many accounts existed on the enddate
# How many accounts were active between the startdate and the enddate (inclusive of endpoints) 
#	What percentage of existing accounts were active during the date range (also inclusive)

# Returns results as a data frame.

# Also has an option to filter out internal users (filter_internals = T)

calculate_WAU <-
  function(
    startdate,
    enddate,
    filter_internals = F, 
    u.d = user.dimensions,
    up.f = user_platformaction.facts,
    c.f = champion.facts
  ){
    existing_user.dimensions <- u.d %>%
      left_join(c.f, by = "champion_id") %>%
      filter(account_created_date <= enddate) %>%
      {
        if(filter_internals){
          filter(., account_type != "Internal User")
        } else {.}
      }
    
    existing_user.count <- existing_user.dimensions %>% 
      group_by(champion_group) %>%
      summarise(count_distinct_existing_users = length(unique(user_id))) %>%
      {
        rbind(.,
              data.frame(champion_group = "all", count_distinct_existing_users = sum(.$count_distinct_existing_users))
        )
      }
    
    existing_user.count %<>%
      {
        left_join(
          unique(select(champion.facts, champion_group)),
          .
        )
      } %>% 
      mutate(
        count_distinct_existing_users = 
          ifelse(
            is.na(count_distinct_existing_users), 
            0, 
            count_distinct_existing_users
          )
      )
    
    user_platformaction_daterange.facts <- up.f %>%
      filter(platformaction_date <= enddate, platformaction_date >= startdate) %>%
      inner_join(existing_user.dimensions, by = "user_id")
    
    active_user.count <- user_platformaction_daterange.facts %>%
      group_by(champion_group) %>%
      summarise(count_distinct_active_users = length(unique(user_id))) %>%
      {
        rbind(
          .,   
          data.frame(
            champion_group = "all", 
            count_distinct_active_users = sum(.$count_distinct_active_users)
          )
        )
      }
    
    left_join(
      existing_user.count,
      active_user.count
      ) %>% 
      mutate(
        count_distinct_active_users = 
          ifelse(
            is.na(count_distinct_active_users), 
            0, 
            count_distinct_active_users
          )
      ) %>% 
      mutate(
        percent_active_users = 
          count_distinct_active_users/count_distinct_existing_users
      )
      
  }
