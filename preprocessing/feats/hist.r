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

DF <- data.frame(ID = prop$Group.1,
                 Prop.Noshows = prop$x,
                 Hist.Noshows = hist.show$x,
                 Hist.Scheds = hist.all$x)

dd <- cbind(dd[order(dd$PatientId),],
            DF[rep(DF$ID, DF$Hist.Scheds), 2:4])

dd <- dd[-is.na(dd),]
