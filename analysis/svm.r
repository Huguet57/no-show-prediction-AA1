# 1. Carreguem dades
setwd("~/Documents/andreu/no-show-prediction-AA1/analysis")
dd.full <- read.csv("../data_numeric.csv",
                    fileEncoding = 'UTF-8')

# 3. Separem informació, identificadors i target
no.show <- dd.full[, 4]
dd.num <- dd.full[, -c(2, 4, 12)] # Patient ID, No.show nor Training
dd.num$DateDiff <- NULL

library(MASS)
# 3. Normalitzem
dd.num.s <- scale(dd.num)

# 5. Calculem les dimensions reduïdes
N <- nrow(dd.num.s)
d <- ncol(dd.num.s)

# 4. Separem training i test
bin.show <- as.numeric(no.show) - 1

dd.training <- as.matrix(dd.num.s[dd.full$Training == 1, ])
dd.test <- as.matrix(dd.num.s[dd.full$Training == 0, ])

show.training <- as.matrix(bin.show[dd.full$Training == 1])
show.test <- as.matrix(bin.show[dd.full$Training == 0])

# 4. Ampliem training set per igualar classes
ids.showups <- which(show.training == 1)
ids.noshow <- which(show.training == 0)

rand.resamples <- sample(x = ids.noshow,
                         size = length(ids.showups),
                         replace = TRUE)

dd.training.amp <- rbind(dd.training[ids.showups,],
                         dd.training[rand.resamples,])

show.training.amp <- c(show.training[ids.showups],
                       bin.show[rand.resamples])

library(e1071)
# 6. Preparem el SVM
for (C in 10^seq(-3,2)) {
  (svm.out <- svm(dd.training[1:2000,],
                  show.training[1:2000],
                  kernel = "radial",
                  probability = TRUE,
                  class_weight = 'balanced', # penalize
                  cost = C))
  
  pred <- predict(svm.out,
                  newdata = dd.test,
                  type = "response")
 
  (conf.table <- table(show.test, pred > 0))
  print(G)
  print(sum(diag(conf.table))/sum(conf.table))
}