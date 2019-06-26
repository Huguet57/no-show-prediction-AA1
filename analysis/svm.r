library(e1071)

# 1. Preparem el K-fold Cross Validation
k <- 10 
folds <- sample(rep(1:k, length=N), N, replace=FALSE) 
valid.error <- rep(0,k)

res <- data.frame(C = integer(),
                  g = integer(),
                  error = integer())

# 2. Executem el SVM - Busquem la C i gamma òptimes
for (C in 10^seq(-3,2)) {
  for (g in 2^seq(-2,2)) {
    for (i in 1:k) { 
      # cat("C =", C, "gamma =", g, "kCV =", i, "\n")
      # for building the model (training)
      train <- data.frame(dd.num.s[folds!=i,],
                          no.show = no.show[folds!=i])
      # for prediction (validation)
      valid <- data.frame(dd.num.s[folds==i,],
                          no.show = no.show[folds==i])
      
      x_train <- train[1:1000,]
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
      
      conf.table <- table(valid$no.show, pred)
      valid.error[i] <- 1 - sum(diag(conf.table))/sum(conf.table)
    }
    val.error <- 100*sum(valid.error)/length(valid.error)
    cat("C =", C, "Gamma =", g, "Validation Error = ", val.error, "\n")
    res <- rbind(res, data.frame(C = C, g = g, error = val.error))
  }
}

print(res)