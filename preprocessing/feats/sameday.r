Days <- unique(dd$AppointDay)
Months <- unique(dd$AppointMonth)
Locations <- unique(dd$Neighbourhood)

DML <- expand.grid(Days = Days,
                  Months = Months,
                  Locations = Locations)

DML <- as.data.frame(DML)
N <- nrow(DML)

library(parallel)
numCores <- detectCores()
cl <- makeCluster(numCores)

library(foreach)
library(doParallel)
registerDoParallel(cl)

system.time({
  res <- foreach (i=1:N, .combine = rbind) %dopar% {
    people.same.day <- which(dd$AppointDay == DML[i,]$Days &
                             dd$AppointMonth == DML[i,]$Months &
                             dd$Neighbourhood == DML[i,]$Locations)
    
    if (length(people.same.day) > 0) {
      data.frame(AppointmentID = dd[people.same.day,]$AppointmentID,
                 People.some.day = rep(length(people.same.day),
                                       length(people.same.day)))
    }
    
    # TODO: Can we do something with AppointmentID? It is ordered by time (?)
  }
})

stopCluster(cl)
dd <- merge(dd, res, by = "AppointmentID")
