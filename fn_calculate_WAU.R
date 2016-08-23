# Function: calculate_WAU

# Given a date range, calculates:
#	How many accounts existed by the end (including last day)
# 	How many accounts were active during the date range (inclusive of endpoints) 
#	What percentage of existing accounts were active during the date range (also inclusive)

# Also has an option to filter out internal users (filter_internals = T)

calculate_WAU <-
  function(
    stardate,
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
        }
      }
    
    existing_user.count <- existing_user.dimensions %>% 
      group_by(champion_group) %>%
      summarise(count_distinct_existing_users = length(unique(user_id))) %>%
      {
        rbind(.,
              c("all", sum(.$count_distinct_existing_users))
        )
      }
    
    user_platformaction_daterange.facts <- up.f %>%
      filter(platformaction_date <= enddate, platformaction_date >= startdate) %>%
      inner_join(existing_user.dimensions, by = "user_id")
    
    active_user.count <- user_platformaction_daterange.facts %>%
      group_by(champion_group) %>%
      summarise(count_distinct_active_users = length(unique(user_id))) %>%
      {
        rbind(.,
              c("all", sum(.$count_distinct_active_users))
        )
      }
    
    inner_join(
      existing_user.count,
      active_user.count
      ) %>%
      mutate(percent_active_users = count_distinct_active_users/count_distinct_existing_users)
      
  }
