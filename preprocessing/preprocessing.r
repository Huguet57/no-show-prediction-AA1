# 1. Loading of resources
# 1.1. Data loading
# DIR <- 'C://Users/Administrador 2/Desktop/no-show-prediction-AA1/'
# DIR <- 'C://Users/andreu.huguet/Desktop/no-show-prediction-AA1-master/'
DIR <- '~/no-show-prediction-AA1/'
setwd(paste(DIR, "preprocessing/", sep = ""))
dd <- read.csv(paste(DIR, "hospital.csv", sep = ""),
               fileEncoding = 'UTF-8')

# 1.1. Load a file with functions
source("./norm/functions.r")

# 2. Variable normalitzation and re-labeling
# 2.1. Factorize binary variables
source("./norm/factorize.r")

# 2.2. Date normalitzation
source("./norm/datenorm.r")

# 3. Anomaly detection
# 3.1 Removal of missing values
dd <- dd[-which(dd$Age == -1),]
dd <- dd[-which(dd$DateDiff < 0),]

# 4. Separation of training and test data
source("./traintest.r")

# 5. Feature extraction
# 5.1. Patient attendance historial
source("./feats/hist.r")

dd <- rbind(dd.training.amp,
            dd.test.amp)

# 5.2. Neighbourhood socio-economic data
source("./feats/neighs.r")

# 5.3. People flow on the same location on the same date
source("./feats/sameday.r")

summary(dd[dd$Training == 0,])
dd <- dd[-which(dd$Barri.Population == 0),]

# 6. Export processed data to file 
write.csv(dd,
          file = paste(DIR, 'data_training.csv', sep = "/"),
          fileEncoding = "UTF-8",
          row.names = FALSE)