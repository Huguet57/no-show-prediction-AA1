# Select random patients
patIDs <- unique(dd$PatientId)
N <- length(patIDs)/3
test.pats <- patIDs[sample(1:N)]
test.pats.df <- data.frame(PatientId = test.pats)

# Get last visit from each selected patient
dd <- dd[order(dd$AppointmentID),]
test.pats.amp <- merge(test.pats.df, dd, by = "PatientId")
last.visits <- which(!duplicated(test.pats.amp$PatientId))

# Test: last visits of random patients
dd.test <- cbind(test.pats.amp[last.visits,],
                 data.frame(Training = 0))

# Training: the rest
dd.diff <- setdiff(dd$AppointmentID, dd.test$AppointmentID)
training.ids <- match(dd.diff, dd$AppointmentID)
dd.training <- cbind(dd[training.ids,],
                     data.frame(Training = 1))