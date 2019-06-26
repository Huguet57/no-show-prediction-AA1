library(DMwR)
# Executem kNN - busquem la k òptima
for (k in 2:sqrt(N)) {
  knn.out <- kNN(no.show ~ .,
                 train = df.training,
                 test = df.test,
                 k = 5)
  
  (conf.tb <- table(show.test, knn.out))
  cat("K =", k, "Accuracy =" , sum(diag(conf.tb))/sum(conf.tb), "\n")
}