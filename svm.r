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
    for (i in 1:k) { 
      cat("C =", C, "gamma =", g, "kCV =", i, "\n")
      # for building the model (training)
      train <- data.frame(dd.num.s[folds!=i,],
                          no.show = no.show[folds!=i])
      # for prediction (validation)
      valid <- data.frame(dd.num.s[folds==i,],
                          no.show = no.show[folds==i])
      
      x_train <- train[1:2000,]
      summary(x_train)
      
      (svm.out <- svm(no.show ~ .,
                      data = x_train,
                      kernel = "radial",
                      probability = TRUE,
                      class_weight = 'balanced', # penalize
                      cost = C,
                      gamma = g))
      
      pred <- predict(svm.out,
                      newdata = valid,
                      type = "response")
      
      cat(conf.table <- table(valid$no.show, pred), "\n")
      cat(valid.error[i] <- sum(diag(conf.table))/sum(conf.table), "\n")
    }
    val.error <- 100*sum(valid.error)/length(valid.error)
    cat("C =", C, "Gamma =", g, "Validation Error = ", val.error, "\n")
  }
}
