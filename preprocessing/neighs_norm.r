DIR <- 'C:\\Users\\andreu.huguet\\Downloads\\no-show-prediction-AA1-master\\'
setwd(DIR)
dd <- read.csv(paste(DIR, "data.csv", sep=""),
               fileEncoding = 'UTF-8')

?read.csv

dd[sample(1:nrow(dd), size = 10),]
neighs <- dd$Neighbourhood

barris <- read.csv("./preprocessing/barri_info/barris_info.csv",
                   fileEncoding = "UTF-8")

library(textclean)

neighs.norm <- replace_non_ascii(neighs)
neighs.norm <- sub("´", "", neighs.norm, fixed = TRUE)
neighs.norm <- gsub(" ", "_", neighs.norm, fixed = TRUE)
neighs.norm <- sapply(neighs.norm, tolower)

neighs.norm <- sub("_do_", "_", neighs.norm)
neighs.norm <- sub("_das_", "_", neighs.norm)
neighs.norm <- sub("_da_", "_", neighs.norm)
neighs.norm <- sub("_de_", "_", neighs.norm)

barris$Barrio <- sub("_do_", "_", barris$Barrio)
barris$Barrio <- sub("_das_", "_", barris$Barrio)
barris$Barrio <- sub("_da_", "_", barris$Barrio)
barris$Barrio <- sub("_de_", "_", barris$Barrio)

intersect(sort(neighs.norm), barris$Barrio)

U <- union(sort(neighs.norm), barris$Barrio)
I <- intersect(sort(neighs.norm), barris$Barrio)

setdiff(sort(neighs.norm), barris$Barrio)
setdiff(barris$Barrio, sort(neighs.norm))

dd$Neighbourhood <- neighs.norm

head(dd)
tail(dd)

# Dues persones que han fet no s'han presentat al doctor
dd <- dd[-(dd$Neighbourhood == "ilhas_oceanicas_trindade"),]

# Procedim a unir la info socioeconòmica dels barris a les dades 

head(barris)

dd$Barri.Population <- rep(NA, nrow(dd))
dd$Barri.Area <- rep(NA, nrow(dd))
dd$Barri.Density <- rep(NA, nrow(dd))
dd$Barri.Renda <- rep(NA, nrow(dd))

for (k in 1:nrow(barris)) {
  people.from.k <- which(barris$Barrio[k] == dd$Neighbourhood)
  dd[people.from.k,]$Barri.Population <- barris$Population[k]
  dd[people.from.k,]$Barri.Area <- barris$Area[k]
  dd[people.from.k,]$Barri.Density <- barris$Density[k]
  dd[people.from.k,]$Barri.Renda <- barris$Renda[k]
}

dd[sample(1:nrow(dd), size = 10),]

hist(dd$SchedMonth)
hist(dd$AppointMonth)

write.csv(barris,
          file = "./preprocessing/barri_info/barris_info.csv",
          fileEncoding = "UTF-8",
          row.names = FALSE)

write.csv(dd,
          file = "./preprocessing/data_with_neighs.csv",
          fileEncoding = "UTF-8",
          row.names = FALSE)
