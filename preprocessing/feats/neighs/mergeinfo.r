# colnames(barris) <- c("X", "Neighbourhood", "Area", "Population", "Men", "Women", "Renda", "Density")
# merge(dd, barris, by = "Neighbourhood")

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