library(FactoMineR)

# DIR <- '~/no-show-prediction-AA1/'
# setwd(paste(DIR, "preprocessing/", sep = ""))
DIR <- '~/Documents/andreu/no-show-prediction-AA1/'
dd <- read.csv(paste(DIR, "data_training.csv", sep = ""),
               fileEncoding = 'UTF-8')

colnames(dd)
factors <- c(3, 5:11)
dd.factors <- dd[,factors]
mca.out <- MCA(dd.factors, graph = FALSE)

mca.dims <- mca.out$ind$coord
dd.num <- cbind(dd[,-factors], mca.dims)

summary(dd.num)

# Export processed data to file 
write.csv(dd.num,
          file = paste(DIR, 'data_numeric.csv', sep = "/"),
          fileEncoding = "UTF-8",
          row.names = FALSE)