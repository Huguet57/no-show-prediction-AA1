IDs <- unique(dd$PatientId)
dd$Prop.Noshows <- rep(NA, nrow(dd))
dd$Hist.Noshows <- rep(NA, nrow(dd))
dd$Hist.Scheds <- rep(NA, nrow(dd))

for (i in 1:length(IDs)) {
  people.with.id <- which(dd$PatientId == IDs[i])
  N.noshows <- sum(dd[people.with.id,]$No.show == "NoShow")
  N.scheds <- nrow(dd[people.with.id,])
  
  dd[people.with.id,]$Prop.Noshows <- N.noshows/N.scheds
  dd[people.with.id,]$Hist.Noshows <- N.noshows
  dd[people.with.id,]$Hist.Scheds <- N.scheds
}