# one-off: create_champion_facts_dataset

label_includes_0 <- read.csv("label_includes.csv", stringsAsFactors = F)

label_includes <- label_includes_0 %>%
  group_by(Label) %>%
  do(
      data.frame(
        Includes = as.character(unlist(strsplit(.$Includes[1], ", ")))
      )
  )

internal_champions <- 
  c(12, 40, 47:52, 54, 59, 60, 68, 77, 78, 81, 106, 115, 116, 146, 147, 157)

champion_facts <- read.csv("champion_facts.csv", stringsAsFactors = F) %>%
  left_join(
    select(label_includes, Label, champion_name = Includes)
  ) %>%
  mutate(
    Label = 
      ifelse(
        champion_id %in% internal_champions | grepl("Gloo", champion_id, ignore.case = T),
        "Internal Champion",
        Label
      )
  ) %>%
  mutate(
    Label =
      ifelse(is.na(Label), "Other", Label)
  ) %>%
  select(-X) %>% 
  write.csv(file = "champion_facts_final.csv", row.names = F)


