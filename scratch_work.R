cvar <- c("2015-11-01","2015-11-02","All")
nvar1 <- c(12,10,5)
nvar2 <- c(7,5,6)
data <- cbind.data.frame(cvar,nvar1,nvar2)

data %>%
  rbind(list("add", sum(nvar1), sum(nvar2)))