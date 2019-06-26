library(randomForest)
# 6. Provem Random Forests
rf <- randomForest(no.show ~ .,
                   data = df.training,
                   ntree = 500,
                   replace = TRUE,
                   nodesize = 3,
                   do.trace = 25)

par(mar=c(5.1,4.1,4.1,2.1) + c(0,4,0,4))
barplot(rf$importance[order(rf$importance)],
        names.arg = rownames(rf$importance)[order(rf$importance)],
        main = "Importance of the variables",
        horiz = TRUE,
        las = 1)

summary(df.test$no.show)

pred <- predict(rf,
                newdata = df.test)
summary(pred)

(conf.tb <- table(show.test, pred))
sum(diag(conf.tb))/sum(conf.tb)

