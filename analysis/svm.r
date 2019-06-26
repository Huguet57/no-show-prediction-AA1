# 1. Carreguem dades
# setwd("~/Documents/andreu/no-show-prediction-AA1/analysis")
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


# CODI DAVID. ÉS LA IDEA TREBALLADA AL LAB. CV per trobar C i gamma òptims

k <- 10 
folds <- sample(rep(1:k, length=N), N, replace=FALSE) 

valid.error <- rep(0,k)

for (C in 10^seq(-3,2)) {
  for (g in 2^seq(-2,2)) {
    for (i in 1:k) 
    { 
      cat("kCV = %d", i)
      train <- dd.full[folds!=i,] # for building the model (training)
      valid <- dd.full[folds==i,] # for prediction (validation)
      
      x_train <- train[, -c(2, 4, 12)]
      t_train <- train[, 4]
      
      (svm.out <- svm(x_train[1:2000,],
                      t_train[1:2000,],
                      kernel = "radial",
                      probability = TRUE,
                      class_weight = 'balanced', # penalize
                      cost = C,
                      gamma = g))
      
      pred <- predict(svm.out,
                      newdata = dd.full,
                      type = "response")
      
      conf.table <- table(show.test, pred > 0)
      valid.error[i] <- sum(diag(conf.table))/sum(conf.table)
    }
    val.error <- 100*sum(valid.error)/length(valid.error)
    cat("C = %d, Gamma = %d, Validation Error = %d\n", C, g, val.error)
  }
}
