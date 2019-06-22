DIR <- '~/no-show-prediction-AA1/'
setwd(paste(DIR, "analysis/", sep = ""))
dd.num <- read.csv(paste(DIR, "data_numeric.csv", sep = ""),
               fileEncoding = 'UTF-8')

no.show <- dd.num[, 4]
dd.num <- dd.num[, -c(2,4)] # Patient ID and No.show

head(dd.num)

dds <- scale(dd.num)
dds <- cbind(dd.num, no.show)
summary(dds)

# Separant training i test
N <- nrow(dd.num)/3
random.ids <- sample(1:N)

dds$DateDiff <- NULL

training.data <- dds[-random.ids,]
test.data <- dds[random.ids,]

training <- training.data

mod.training <- glm(no.show ~ .,
                    data = training.data,
                    family = "binomial")

pred.training <- predict(mod.training,
                         newdata = test.data,
                         type = "response")

summary(pred.training)

length(pred.training)
length(test.data$no.show)

(conf.table.T <- table(pred.training > 0.5, test.data$no.show))
sum(diag(conf.table.T))/sum(conf.table.T)
