# 1. Carreguem dades
dd.full <- read.csv("../data_numeric.csv",
                    fileEncoding = 'UTF-8')

# 2. Separem informació, identificadors i target
no.show <- dd.full[, 4]
dd.num <- dd.full[, -c(2, 4, 12)] # Patient ID, No.show nor Training
dd.num$DateDiff <- NULL

library(MASS)
# 3. Normalitzem les variables
dd.num.s <- scale(dd.num)

# 4. Calculem les dimensions de les variables
N <- nrow(dd.num.s)
d <- ncol(dd.num.s)

# 5. Separem training i test
bin.show <- as.numeric(no.show) - 1

dd.training <- as.matrix(dd.num.s[dd.full$Training == 1, ])
dd.test <- as.matrix(dd.num.s[dd.full$Training == 0, ])

show.training <- as.matrix(bin.show[dd.full$Training == 1])
show.test <- as.matrix(bin.show[dd.full$Training == 0])

# 6. Fem els data.frames de training i test
M <- 1000 # N # es pot canviar per fer proves
df.training <- data.frame(dd.training[1:M, ],
                          no.show = show.training[1:M])
df.test <- data.frame(dd.test,
                      no.show = show.test)

# 7. Resampling - Ampliem la classe minoritària del training set
ids.showups <- which(show.training == 1)
ids.noshow <- which(show.training == 0)

rand.resamples <- sample(x = ids.noshow,
                         size = length(ids.showups),
                         replace = TRUE)

dd.training.amp <- rbind(dd.training[ids.showups,],
                         dd.training[rand.resamples,])

show.training.amp <- c(show.training[ids.showups],
                       bin.show[rand.resamples])

# 8. Executem el mètode
