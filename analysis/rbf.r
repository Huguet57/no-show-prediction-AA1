setwd("~/Documents/andreu/no-show-prediction-AA1/analysis")
dd.full <- read.csv("../data_numeric.csv",
                   fileEncoding = 'UTF-8')

no.show <- dd.full[, 4]
dd.num <- dd.full[, -c(2, 4, 12)] # Patient ID, No.show nor Training
dd.num$DateDiff <- NULL

dd.num.s <- scale(dd.num)

N <- nrow(dd.num.s)
d <- ncol(dd.num.s)

library(neural)
bin.show <- as.numeric(no.show) - 1

dd.training <- as.matrix(dd.num.s[dd.full$Training == 1, ])
dd.test <- as.matrix(dd.num.s[dd.full$Training == 0, ])

show.training <- as.matrix(bin.show[dd.full$Training == 1])
show.test <- as.matrix(bin.show[dd.full$Training == 0])

M <- round(sqrt(N))

# For comparison, we use the same number of centers (M)
data <- rbftrain (dd.training,
                  M,
                  show.training,
                  it = 40,
                  visual = FALSE)


# And make it predict the same test data
preds <- rbf (dd.test,
              data$weight,
              data$dist,
              data$neurons,
              data$sigma)

summary(preds)

show.test.neat <- show.test[-is.na(preds),]
preds.neat <- preds[-is.na(preds),]

(conftb <- table(show.test.neat, preds.neat > 0.6))
sum(diag(conftb))/sum(conftb)

## And now the normalized error of this prediction
# N.test <- nrow(show.test.neat)
# (errorsTest <- sqrt(sum((show.test.neat - preds.neat)^2)/((N.test-1)*var(show.test.neat))))

## The results are poorer, with an advantage for the former method (using clustering)
# 1-errorsTest^2

