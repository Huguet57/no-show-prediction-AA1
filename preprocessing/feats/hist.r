system.time({
  prop <- aggregate(as.integer(dd$No.show == "Show"),
                   by=list(dd$PatientId),
                   FUN=mean)
  
  hist.show <- aggregate(as.integer(dd$No.show == "Show"),
                         by=list(dd$PatientId),
                         FUN=sum)
  
  hist.all <- aggregate(rep(1, nrow(dd)),
                         by=list(dd$PatientId),
                         FUN=sum)
})

DF <- data.frame(PatientId = prop$Group.1,
                 Prop.Shows = prop$x,
                 Hist.Shows = hist.show$x,
                 Hist.Scheds = hist.all$x)

dd <- merge(dd, DF, by = "PatientId")