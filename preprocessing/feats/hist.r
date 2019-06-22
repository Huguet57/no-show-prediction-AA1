# Get history of training data
system.time({
  prop <- aggregate(as.integer(dd.training$No.show == "Show"),
                   by=list(dd.training$PatientId),
                   FUN=mean)
  
  hist.show <- aggregate(as.integer(dd.training$No.show == "Show"),
                         by=list(dd.training$PatientId),
                         FUN=sum)
  
  hist.all <- aggregate(rep(1, nrow(dd.training)),
                         by=list(dd.training$PatientId),
                         FUN=sum)
})

DF <- data.frame(PatientId = prop$Group.1,
                 Prop.Shows = prop$x,
                 Hist.Shows = hist.show$x,
                 Hist.Scheds = hist.all$x)

# But merge with all the dataset
# With the training set
dd.training.amp <- merge(dd.training, DF, by = "PatientId")

# With the test set
common.ids <- intersect(test.pats, dd.training$PatientId)
common.rows <- match(common.ids, dd.test$PatientId)
common.rows.amp <- merge(dd.test[common.rows,],
                         DF,
                         by = "PatientId")

N.noncommon <- nrow(dd.test[-common.rows,])
blank.df <- data.frame(Prop.Shows = rep(0, N.noncommon),
                       Hist.Shows = rep(0, N.noncommon),
                       Hist.Scheds = rep(0, N.noncommon))

noncommon.rows.amp <- cbind(dd.test[-common.rows,], blank.df)
dd.test.amp <- rbind(common.rows.amp, noncommon.rows.amp)