# 1. Carreguem dades
setwd("~/Documents/andreu/no-show-prediction-AA1/analysis")
dd.full <- read.csv("../data_numeric.csv",
                    fileEncoding = 'UTF-8')

# 2. Separem informació, identificadors i target
no.show <- dd.full[, 4]
dd.num <- dd.full[, -c(2, 4, 12)] # Patient ID, No.show nor Training
dd.num$DateDiff <- NULL

library(MASS)
# 3. Normalitzem
dd.num.s <- scale(dd.num)

# 4. Separem training i test
bin.show <- as.numeric(no.show) - 1

dd.training <- as.matrix(dd.num.s[dd.full$Training == 1, ])
dd.test <- as.matrix(dd.num.s[dd.full$Training == 0, ])

show.training <- as.matrix(bin.show[dd.full$Training == 1])
show.test <- as.matrix(bin.show[dd.full$Training == 0])

# 5. Calculem les dimensions reduïdes
N <- nrow(dd.num.s)
d <- ncol(dd.num.s)

library(e1071)
# 6. Preparem el SVM
for (C in 10^seq(-3,3)) {
  (svm.out <- svm(dd.training[1:1000,],
                  show.training[1:1000,],
                  kernel = "polynomial",
                  cost = C))
  
  pred <- predict(svm.out,
                  newdata = dd.test,
                  type = "response")
 
  (conf.table <- table(show.test, pred > 0))
  print(C)
  print(sum(diag(conf.table))/sum(conf.table))
}

# 7. K-fold Cross Validation

## a typical choice is k=10
k <- 10 
folds <- sample(rep(1:k, length=N), N, replace=FALSE) 

valid.error <- rep(0,k)


## This function is not intended to be useful for general training purposes, but it is useful for the sake of illustration
## in particular, it does not optimize the value of C (it requires it as parameter)

train.svm.kCV <- function (x_train, t_train, which.kernel, myC, kCV=10) {
  for (i in 1:kCV) {  
    train <- x_train[folds!=i,] # for building the model (training)
    valid <- x_train[folds==i,] # for prediction (validation)
    
    switch(which.kernel,
           linear={model <- svm(x_train, t_train, type="C-classification", cost=myC, kernel="linear", scale = FALSE)},
           poly.2={model <- svm(x_train, t_train, type="C-classification", cost=myC, kernel="polynomial", degree=2, coef0=1, scale = FALSE)},
           poly.3={model <- svm(x_train, t_train, type="C-classification", cost=myC, kernel="polynomial", degree=3, coef0=1, scale = FALSE)},
           RBF={model <- svm(x_train, t_train, type="C-classification", cost=myC, kernel="radial", scale = FALSE)},
           stop("Enter one of 'linear', 'poly.2', 'poly.3', 'radial'"))
    
    x_valid <- valid
    pred <- predict(model,x_valid)
    t_true <- t_train[folds==i,]
    
    # compute validation error for part 'i'
    valid.error[i] <- sum(pred != t_true)/length(t_true)
  }
  # return average validation error
  100*sum(valid.error)/length(valid.error)
}

for (G in 10^seq(-3,-1)) {
  (svm.out <- svm(dd.training[1:1000,],
                  show.training[1:1000,],
                  kernel = "radial",
                  cost = 1e3,
                  gamma = G))
  
  pred <- predict(svm.out,
                  newdata = dd.test,
                  type = "response")
  
  (conf.table <- table(show.test, pred > 0))
  print(G)
  print(sum(diag(conf.table))/sum(conf.table))
}

# 8. Save the data
save(svm.out,
     file = "./svm_without_pca.data")
