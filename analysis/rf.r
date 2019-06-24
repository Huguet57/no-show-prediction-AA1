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
dd.training <- as.matrix(dd.num.s[dd.full$Training == 1, ])
dd.test <- as.matrix(dd.num.s[dd.full$Training == 0, ])

show.training <- no.show[dd.full$Training == 1]
show.test <- no.show[dd.full$Training == 0]

# 5. Fem els datasets
df.training <- data.frame(dd.training,
                          no.show = show.training)

df.test <- data.frame(dd.test,
                      no.show = show.test)

library(randomForest)
# 6. Provem Random Forests
# rf <- randomForest(no.show ~ .,
#                    data = df.training)

rownames(rf$importance)[order(rf$importance, decreasing = TRUE)]
summary(df.test$no.show)

pred <- predict(rf,
                newdata = df.test)
summary(pred)

(conf.tb <- table(df.test$no.show, pred))
sum(diag(conf.tb))/sum(conf.tb)
