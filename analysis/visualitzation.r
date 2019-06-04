DIR <- '~/no-show-prediction-AA1/'
setwd(paste(DIR, "analysis/", sep = ""))
dd <- read.csv(paste(DIR, "data.csv", sep = ""),
               fileEncoding = 'UTF-8')

head(dd)
summary(dd)