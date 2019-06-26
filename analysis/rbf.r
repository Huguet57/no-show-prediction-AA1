library(neural)
bin.show <- as.numeric(no.show) - 1

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

