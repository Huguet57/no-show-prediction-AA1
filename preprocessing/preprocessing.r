# 1. Loading of resources
# 1.1. Data loading
DIR <- '~/no-show-prediction-AA1/'
setwd(paste(DIR, "preprocessing/", sep = ""))
dd <- read.csv(paste(DIR, "hospital.csv", sep = ""),
               fileEncoding = 'UTF-8')

# 1.1. Load a file with functions
source("./fun/functions.r")

# 2. Variable normalitzation and re-labeling
# 2.1. Factorize binary variables
source("./norm/factorize.r")

# 2.2. Date normalitzation
source("./norm/datenorm.r")

# 3. Anomaly detection
# 3.1 Removal of missing values
dd <- dd[-which(dd$Age == -1),]
dd <- dd[-which(dd$DateDiff < 0),]

# 4. Feature extraction
# 4.1. Patient attendance historial
source("./feats/hist.r")

# 4.2. Neighbourhood socio-economic data
source("./feats/neighs.r")

# 4.3. People flow on the same location on the same date
source("./feats/sameday.r")

# 5. Export processed data to file 
write.csv(dd,
          file = paste(DIR, 'data.csv', sep = "/"),
          fileEncoding = "UTF-8",
          row.names = FALSE)
