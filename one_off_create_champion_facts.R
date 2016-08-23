# one-off: create_champion_facts

label_includes_0 <- read.csv("label_includes.csv", stringsAsFactors = F)

label_includes <- label_includes_0 %>%
  group_by(Label) %>%
  do(
      data.frame(
        Includes = as.character(unlist(strsplit(.$Includes[1], ", ")))
      )
  ) 

champion_facts <- read.csv("champion_facts.csv", stringsAsFactors = F) %>%
  left_join(
    select(label_includes, Label, champion_name = Includes)
  ) %>%
  select(-X) %>%
  write.csv(file = "champion_facts_final.csv", row.names = F)


