setwd("~/Documents/andreu/no-show-prediction-AA1/analysis")
dd.full <- read.csv("../data_numeric.csv",
                   fileEncoding = 'UTF-8')

no.show <- dd.full[, 4]
dd.num <- dd.full[, -c(2, 4, 12)] # Patient ID, No.show nor Training
dd.num$DateDiff <- NULL

summary(dd.num)
dd.num.s <- scale(dd.num)
summary(dd.num.s)

N <- nrow(dd.num)
d <- ncol(dd.num)

library(MASS)
library(cclust)

# Function to compute a PHI (N x M) design matrix, without the Phi_0(x) = 1 column;
# c.i, sg.i are the centers and smoothing parameters or variances (sigma_i^2) of the neurons, respectively

sq.norm <- function(x,y) sum((x - y)^2)

PHI <- function (x,c,sg) {
  N <- length(x)
  M <- length(c)
  phis <- matrix(rep(0,M*N), nrow=M)
  for (i in 1:M)
    phis[i,] <- exp(-(x - c[i])^2/(2*sg[i]))
  
  t(phis)
}

## We find the centers and variances for each neuron using k-means;
## since this clustering algorithm is non-deterministic (because the initial centers are random),
## we do it 'NumKmeans' times
NumKmeans <- 2

## We set a rather large number of hidden units (= basis functions) M as a function of 
## data size (the sqrt is just a heuristic!) because we are going to try different regularizers
(M <- floor(sqrt(N)))

# to store the centers and variances
C <- M
expxc <- matrix(0, nrow=NumKmeans, ncol=C)
sg <- matrix(0, nrow=NumKmeans, ncol=C)

for (j in 1:NumKmeans) {
  # Find the centers c.i with k-means
  km.res <- cclust (x = dd.num.s,  # the data is passed as row/column dataframe
                    centers = C,   # the number of centers is heuristic
                    iter.max = 200,
                    method = "kmeans",
                    dist = "euclidean")
  
  c <- km.res$centers
  interval <- c(1, C)
  
  # Obtain the variances sp.i as a function of the c.i
  sg[j,] <- rep(0, C)
  
  for (i in interval) {
    indexes <- which(km.res$cluster == i)
    (l.i <- length(indexes))
    
    # repeated.c <- c[i + 1,]
    repeated.c <- do.call("rbind", replicate(N, c[i,], simplify = FALSE))
    expxc[j,i] <- euc.dist(dd.num.s, repeated.c)
    repeated.c <- do.call("rbind", replicate(l.i, c[i,], simplify = FALSE))
    
    tail(dd.num.s[indexes,])
    tail(repeated.c)
    
    (sg[j, i] <- euc.dist(dd.num.s[indexes,], repeated.c)/l.i)
    if (sg[j, i] == 0) sg[j, i] <- 1
  }
}
